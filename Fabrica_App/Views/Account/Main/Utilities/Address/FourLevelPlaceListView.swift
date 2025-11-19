//
//  FourLevelPlaceListView.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI


struct FourLevelPlaceListView: View {
    let regions: [PHRegion]
    let onSelect: (PHRegion, PHProvince, PHCity, PHBarangay) -> Void

    var body: some View {
        NavigationStack {
            List(regions, id: \.name) { region in
                NavigationLink(region.name) {
                    ProvinceList(region: region, onSelect: onSelect)
                }
            }
            .navigationTitle("Regions")
        }
    }
}

private struct ProvinceList: View {
    let region: PHRegion
    let onSelect: (PHRegion, PHProvince, PHCity, PHBarangay) -> Void

    var body: some View {
        List(region.provinces, id: \.name) { province in
            NavigationLink(province.name) {
                CityList(region: region, province: province, onSelect: onSelect)
            }
        }
        .navigationTitle(region.name)
    }
}

private struct CityList: View {
    let region: PHRegion
    let province: PHProvince
    let onSelect: (PHRegion, PHProvince, PHCity, PHBarangay) -> Void

    var body: some View {
        List(province.cities, id: \.name) { city in
            NavigationLink(city.name) {
                BarangayList(region: region, province: province, city: city, onSelect: onSelect)
            }
        }
        .navigationTitle(province.name)
    }
}

private struct BarangayList: View {
    let region: PHRegion
    let province: PHProvince
    let city: PHCity
    let onSelect: (PHRegion, PHProvince, PHCity, PHBarangay) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List(city.barangays, id: \.name) { barangay in
            Button(action: {
                onSelect(region, province, city, barangay)
                dismiss()
            }) {
                HStack {
                    Text(barangay.name)
                    Spacer()
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.gray)
                        .opacity(0.3)
                }
            }
        }
        .navigationTitle(city.name)
    }
}
