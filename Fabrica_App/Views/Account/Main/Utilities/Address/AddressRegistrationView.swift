//
//  AddressRegistrationView.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI

struct AddressRegistrationView: View {
    @StateObject private var viewModel = AddressViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Register Address")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.black)
                    Text("Philippines")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)

                ScrollView {
                    VStack(spacing: 12) {
                        // Region
                        SelectionRow(title: "Region", value: viewModel.selectedRegion?.name ?? "Select region") {
                            viewModel.presentingSelection = .region
                        }

                        // Province
                        SelectionRow(title: "Province", value: viewModel.selectedProvince?.name ?? "Select province") {
                            viewModel.presentingSelection = .province
                        }
                        .disabled(viewModel.selectedRegion == nil)

                        // City / Municipality
                        SelectionRow(title: "City / Municipality", value: viewModel.selectedCity?.name ?? "Select city / municipality") {
                            viewModel.presentingSelection = .city
                        }
                        .disabled(viewModel.selectedProvince == nil)

                        // Barangay
                        SelectionRow(title: "Barangay", value: viewModel.selectedBarangay?.name ?? "Select barangay") {
                            viewModel.presentingSelection = .barangay
                        }
                        .disabled(viewModel.selectedCity == nil)

                        // Street / House No.
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Street / House No.")
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                            TextField("e.g. 123 Sampaloc St.", text: $viewModel.street)
                                .autocapitalization(.words)
                                .disableAutocorrection(true)
                                .padding(12)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black.opacity(0.9), lineWidth: 1)
                                )
                                .foregroundColor(.black)
                        }

                        // ZIP Code
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ZIP Code")
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                            TextField("e.g. 1100", text: $viewModel.zipCode)
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black.opacity(0.9), lineWidth: 1)
                                )
                                .foregroundColor(.black)
                        }

                        // Notes
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Notes (optional)")
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                            TextEditor(text: $viewModel.notes)
                                .frame(minHeight: 80)
                                .padding(8)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black.opacity(0.9), lineWidth: 1)
                                )
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Save button
                Button(action: {
                    viewModel.save {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Save Address")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(viewModel.isValid ? Color.black : Color.white)
                        .foregroundColor(viewModel.isValid ? Color.white : Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isValid)
            }
            .padding()
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(item: $viewModel.presentingSelection) { selection in
                switch selection {
                case .region:
                    SelectionListView<PHRegion>(title: "Select Region",
                                                items: viewModel.regions,
                                                selected: viewModel.selectedRegion) { chosen in
                        viewModel.selectRegion(chosen)
                    }
                case .province:
                    SelectionListView<PHProvince>(title: "Select Province",
                                                  items: viewModel.provincesForSelectedRegion,
                                                  selected: viewModel.selectedProvince) { chosen in
                        viewModel.selectProvince(chosen)
                    }
                case .city:
                    SelectionListView<PHCity>(title: "Select City / Municipality",
                                              items: viewModel.citiesForSelectedProvince,
                                              selected: viewModel.selectedCity) { chosen in
                        viewModel.selectCity(chosen)
                    }
                case .barangay:
                    SelectionListView<PHBarangay>(title: "Select Barangay",
                                                  items: viewModel.barangaysForSelectedCity,
                                                  selected: viewModel.selectedBarangay) { chosen in
                        viewModel.selectBarangay(chosen)
                    }
                }
            }
        }
        .accentColor(.black)
    }
}

private struct SelectionRow: View {
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    Text(value)
                        .font(.system(size: 15))
                        .foregroundColor(value.starts(with: "Select") ? .gray : .black)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }
            .padding(12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.9), lineWidth: 1)
            )
        }
    }
}

struct AddressRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        AddressRegistrationView()
            .preferredColorScheme(.light)
            .previewDevice("iPhone 14")
    }
}
