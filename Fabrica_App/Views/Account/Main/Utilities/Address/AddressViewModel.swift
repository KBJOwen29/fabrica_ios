//
//  AddressViewModel.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import Foundation
import Combine

enum PresentingSelection: Identifiable {
    case region, province, city, barangay
    var id: Int {
        hashValue
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

    // Other fields
    @Published var street: String = ""
    @Published var zipCode: String = ""
    @Published var notes: String = ""

    // Sheet presentation
    @Published var presentingSelection: PresentingSelection?

    private var cancellables = Set<AnyCancellable>()

    init(jsonFileName: String = "philippines") {
        loadData(fileName: jsonFileName)

        // Auto-fill zip code when barangay selected (if available)
        $selectedBarangay
            .compactMap { $0?.postalCode }
            .assign(to: \.zipCode, on: self)
            .store(in: &cancellables)
    }

    var provincesForSelectedRegion: [PHProvince] {
        selectedRegion?.provinces ?? []
    }

    var citiesForSelectedProvince: [PHCity] {
        selectedProvince?.cities ?? []
    }

    var barangaysForSelectedCity: [PHBarangay] {
        selectedCity?.barangays ?? []
    }

    var isValid: Bool {
        // require province/city/barangay/street (zip optional but encouraged)
        return selectedRegion != nil &&
               selectedProvince != nil &&
               selectedCity != nil &&
               selectedBarangay != nil &&
               !street.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

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
        // clear dependent selections
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
        // zip auto-filled by publisher in init if postalCode exists
        presentingSelection = nil
    }

    /// Replace this with your persistence or networking save
    func save(completion: @escaping () -> Void) {
        guard isValid else { return }
        let address: [String: String] = [
            "region": selectedRegion?.name ?? "",
            "province": selectedProvince?.name ?? "",
            "city": selectedCity?.name ?? "",
            "barangay": selectedBarangay?.name ?? "",
            "street": street.trimmingCharacters(in: .whitespacesAndNewlines),
            "zipCode": zipCode.trimmingCharacters(in: .whitespacesAndNewlines),
            "notes": notes.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            #if DEBUG
            print("Saved address:", address)
            #endif
            completion()
        }
    }
}
