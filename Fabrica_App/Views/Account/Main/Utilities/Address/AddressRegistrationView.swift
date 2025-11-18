//
//  AddressRegistrationView.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI

struct AddressRegistrationView: View {
    @Environment(\.dismiss) private var dismiss

    // Typed fields (no dropdowns)
    @State private var region: String = ""
    @State private var province: String = ""
    @State private var city: String = ""
    @State private var barangay: String = ""
    @State private var street: String = ""
    @State private var zipCode: String = ""
    @State private var notes: String = ""

    private var isValid: Bool {
        // Require region, province, city, barangay, and street
        !region.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !province.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !barangay.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !street.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
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
                    labeledField(title: "Region",
                                 placeholder: "e.g. Region 4A",
                                 text: $region)

                    labeledField(title: "Province",
                                 placeholder: "e.g. Quezon Province",
                                 text: $province)

                    labeledField(title: "City / Municipality",
                                 placeholder: "e.g. Lucena City",
                                 text: $city)

                    labeledField(title: "Barangay",
                                 placeholder: "e.g. Ibabang Dupay",
                                 text: $barangay)

                    labeledField(title: "Street / House No.",
                                 placeholder: "e.g. 123 Sampaloc St.",
                                 text: $street,
                                 capitalize: true)

                    labeledField(title: "ZIP Code",
                                 placeholder: "e.g. 4301",
                                 text: $zipCode,
                                 keyboard: .numberPad)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Notes (optional)")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        TextEditor(text: $notes)
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

            Button(action: saveAndDismiss) {
                Text("Save Address")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(isValid ? Color.black : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!isValid)
        }
        .padding()
        .navigationTitle("Register Address")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }

    // MARK: - Helpers

    private func labeledField(title: String,
                              placeholder: String,
                              text: Binding<String>,
                              keyboard: UIKeyboardType = .default,
                              capitalize: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.black)
            TextField(placeholder, text: text)
                .textInputAutocapitalization(capitalize ? .words : .never)
                .disableAutocorrection(true)
                .keyboardType(keyboard)
                .padding(12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.9), lineWidth: 1)
                )
                .foregroundColor(.black)
        }
    }

    private func saveAndDismiss() {
        // Replace with your real persistence.
        let address: [String: String] = [
            "region": region.trimmingCharacters(in: .whitespacesAndNewlines),
            "province": province.trimmingCharacters(in: .whitespacesAndNewlines),
            "city": city.trimmingCharacters(in: .whitespacesAndNewlines),
            "barangay": barangay.trimmingCharacters(in: .whitespacesAndNewlines),
            "street": street.trimmingCharacters(in: .whitespacesAndNewlines),
            "zipCode": zipCode.trimmingCharacters(in: .whitespacesAndNewlines),
            "notes": notes.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        #if DEBUG
        print("Saved address (typed):", address)
        #endif
        dismiss()
    }
}

struct AddressRegistrationView_Preview: PreviewProvider {
    static var previews: some View {
        AddressRegistrationView()
    }
}
