//
//  AddressViewModel.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import Foundation
import Combine

// MARK: - Selection Sheet Kind
enum PresentingSelection: Identifiable {
    case region, province, city, barangay
    var id: Int { hashValue }
}

// MARK: - Persisted Address Entry (per-account or guest)
public struct AddressEntry: Codable, Identifiable, Equatable {
    public let id: UUID
    public let region: String
    public let province: String
    public let city: String
    public let barangay: String
    public let notes: String?
    public let createdAt: Date

    public init(region: String, province: String, city: String, barangay: String, notes: String?) {
        self.id = UUID()
        self.region = region
        self.province = province
        self.city = city
        self.barangay = barangay
        self.notes = notes?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true ? nil : notes
        self.createdAt = Date()
    }
}

final class AddressViewModel: ObservableObject {
    // Data source
    @Published var regions: [PHRegion] = []

    // Selected items (for building a new address)
    @Published var selectedRegion: PHRegion?
    @Published var selectedProvince: PHProvince?
    @Published var selectedCity: PHCity?
    @Published var selectedBarangay: PHBarangay?

    // Optional notes
    @Published var notes: String = ""

    // Sheet presentation
    @Published var presentingSelection: PresentingSelection?

    private var cancellables = Set<AnyCancellable>()

    init(jsonFileName: String = "philippines") {
        loadData(fileName: jsonFileName)
    }

    // Derived lists
    var provincesForSelectedRegion: [PHProvince] {
        selectedRegion?.provinces ?? []
    }

    var citiesForSelectedProvince: [PHCity] {
        selectedProvince?.cities ?? []
    }

    var barangaysForSelectedCity: [PHBarangay] {
        selectedCity?.barangays ?? []
    }

    // Validation: require region/province/city/barangay
    var isValid: Bool {
        return selectedRegion != nil &&
               selectedProvince != nil &&
               selectedCity != nil &&
               selectedBarangay != nil
    }

    // Load PH hierarchy JSON
    func loadData(fileName: String) {
        if let dataURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let raw = try Data(contentsOf: dataURL)
                let decoded = try JSONDecoder().decode([PHRegion].self, from: raw)
                DispatchQueue.main.async {
                    self.regions = decoded
                }
            } catch {
                #if DEBUG
                print("Failed to load \(fileName).json:", error)
                #endif
            }
        } else {
            #if DEBUG
            print("\(fileName).json not found in bundle.")
            #endif
        }
    }

    // Selection helpers
    func selectRegion(_ region: PHRegion) {
        selectedRegion = region
        selectedProvince = nil
        selectedCity = nil
        selectedBarangay = nil
        presentingSelection = nil
    }

    func selectProvince(_ province: PHProvince) {
        selectedProvince = province
        selectedCity = nil
        selectedBarangay = nil
        presentingSelection = nil
    }

    func selectCity(_ city: PHCity) {
        selectedCity = city
        selectedBarangay = nil
        presentingSelection = nil
    }

    func selectBarangay(_ barangay: PHBarangay) {
        selectedBarangay = barangay
        presentingSelection = nil
    }

    // Save a newly composed address using current selections
    func save(completion: @escaping () -> Void) {
        guard isValid else { return }

        let ownerEmail = Self.storageOwnerEmail()
        let entry = AddressEntry(
            region: selectedRegion?.name ?? "",
            province: selectedProvince?.name ?? "",
            city: selectedCity?.name ?? "",
            barangay: selectedBarangay?.name ?? "",
            notes: notes
        )

        var list = Self.loadAddresses(for: ownerEmail)
        list.append(entry)
        Self.saveAddresses(list, for: ownerEmail)
        Self.saveSelectedAddress(entry.id, for: ownerEmail) // auto-select new

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion()
        }
    }
}

// MARK: - Simple UserDefaults storage (per email or guest)
extension AddressViewModel {
    // Use current signed-in user's email, otherwise guest bucket
    static func storageOwnerEmail() -> String {
        if let email = AuthService.shared.currentUser?.getEmail() {
            return email
        } else {
            return "__guest__"
        }
    }

    private static func storageKey(for email: String) -> String {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return "addresses_storage_v1_\(trimmed)"
    }

    static func loadAddresses(for email: String) -> [AddressEntry] {
        let key = storageKey(for: email)
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([AddressEntry].self, from: data)
        } catch {
            #if DEBUG
            print("Failed to decode addresses for \(email):", error)
            #endif
            return []
        }
    }

    static func saveAddresses(_ addresses: [AddressEntry], for email: String) {
        let key = storageKey(for: email)
        do {
            let data = try JSONEncoder().encode(addresses)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            #if DEBUG
            print("Failed to encode addresses for \(email):", error)
            #endif
        }
    }
}

// MARK: - Selected (Active) Address Persistence
extension AddressViewModel {
    private static func selectedKey(for email: String) -> String {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return "selected_address_v1_\(trimmed)"
    }

    static func loadSelectedAddress(for email: String) -> AddressEntry? {
        let key = selectedKey(for: email)
        guard let idString = UserDefaults.standard.string(forKey: key),
              let uuid = UUID(uuidString: idString) else {
            return nil
        }
        let all = loadAddresses(for: email)
        return all.first(where: { $0.id == uuid })
    }

    static func saveSelectedAddress(_ id: UUID, for email: String) {
        let key = selectedKey(for: email)
        UserDefaults.standard.set(id.uuidString, forKey: key)
    }

    static func currentSelectedAddress() -> AddressEntry? {
        let email = storageOwnerEmail()
        return loadSelectedAddress(for: email) ?? loadAddresses(for: email).last
    }

    static func selectAddress(_ entry: AddressEntry) {
        let email = storageOwnerEmail()
        saveSelectedAddress(entry.id, for: email)
    }
}
