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

    // Selected items
    @Published var selectedRegion: PHRegion?
    @Published var selectedProvince: PHProvince?
    @Published var selectedCity: PHCity?
    @Published var selectedBarangay: PHBarangay?

    // Optional notes (street/zip removed)
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

    // Load PH hierarchy JSON (ensure philippines.json is complete)
    func loadData(fileName: String) {
        if let data = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let raw = try Data(contentsOf: data)
                let decoded = try JSONDecoder().decode([PHRegion].self, from: raw)
                DispatchQueue.main.async {
                    self.regions = decoded
                }
            } catch {
                #if DEBUG
                print("Failed to load philippines data:", error)
                #endif
            }
        } else {
            #if DEBUG
            print("philippines.json not found in bundle. Use philippines_sample.json as a template.")
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

    // Save to storage (per current user if present, otherwise guest storage)
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion()
        }
    }
}

// MARK: - Simple UserDefaults storage (per email or guest)
extension AddressViewModel {
    // Use current signed-in user's email, otherwise a guest bucket so UI can be tested without login
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
