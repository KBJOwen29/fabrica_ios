//
//  AddressList.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import SwiftUI

struct AddressList: View {
    @ObservedObject private var auth = AuthService.shared
    @State private var addresses: [AddressEntry] = []
    @State private var showingAddSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                if addresses.isEmpty {
                    VStack(spacing: 12) {
                        Text("No saved addresses yet.")
                            .foregroundColor(.gray)
                        Button(action: { showingAddSheet = true }) {
                            Text("Add Address")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(addresses) { addr in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(addr.barangay)
                                    .font(.headline)
                                Text("\(addr.city), \(addr.province)")
                                    .font(.subheadline)
                                Text(addr.region)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                if let notes = addr.notes, !notes.isEmpty {
                                    Text(notes)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 2)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }

                // Persistent bottom "Add New Address" button
                VStack {
                    Spacer()
                    Button(action: { showingAddSheet = true }) {
                        Text("Add New Address")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                    }
                    .padding(.bottom, 12)
                }
            }
            .navigationTitle("My Addresses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear(perform: reload)
        .onReceive(auth.$currentUser) { _ in
            // Keep in sync if user signs in/out; still shows data (guest or user)
            reload()
        }
        .sheet(isPresented: $showingAddSheet, onDismiss: {
            reload()
        }) {
            AddressRegistrationView()
        }
    }

    private func reload() {
        let owner = AddressViewModel.storageOwnerEmail() // current user or guest
        addresses = AddressViewModel.loadAddresses(for: owner)
    }
}

struct AddressList_Previews: PreviewProvider {
    static var previews: some View {
        AddressList()
    }
}
