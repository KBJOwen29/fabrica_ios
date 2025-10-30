//
//  Settings.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/7/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var name: String = "Jim Owen K. Bognalbal"
    @State private var number: String = "0968-719-0116"
    @State private var email: String = "jimowen@email.com"
    @State private var password: String = "password"
    
    // Logic-only wiring to reflect local storage values
    @ObservedObject private var auth = AuthService.shared
    private let repo = AccountsRepository.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                // MARK: - Profile Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Profile")
                        .font(.title3)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Edit Name")
                            .font(.subheadline)
                        TextField("Enter name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Edit Number")
                            .font(.subheadline)
                        TextField("Enter number", text: $number)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            Spacer()
                            Button("Save") {
                                guard let user = auth.currentUser else { return }
                                user.setName(newName: name)
                                user.setCellphoneNumber(newCellphone: number)
                                repo.update(user)
                                auth.updateCurrentUserIfSame(user)
                            }
                            .font(.subheadline.bold())
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                
                // MARK: - Account Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account")
                        .font(.title3)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(true) // Email not editable in current UI
                        
                        Text("Password")
                            .font(.subheadline)
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            Spacer()
                            Button("Save") {
                                guard let user = auth.currentUser else { return }
                                user.setPassword(newPassword: password)
                                repo.update(user)
                                auth.updateCurrentUserIfSame(user)
                            }
                            .font(.subheadline.bold())
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                // MARK: - Logout Button
                Button(action: {
                    auth.signOut()
                }) {
                    VStack {
                        Image(systemName: "arrow.left.to.line")
                            .font(.title)
                        Text("Logout")
                            .font(.subheadline)
                    }
                }
                .foregroundColor(.primary)
                
            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Pull values from the restored current user (from local storage)
                if let user = auth.currentUser {
                    name = user.getName() ?? ""
                    number = user.getCellphoneNumber() ?? ""
                    email = user.getEmail()
                    password = user.getPassword()
                }
            }
            .onReceive(auth.$currentUser) { user in
                // Keep fields in sync if signed-in account changes
                if let u = user {
                    name = u.getName() ?? ""
                    number = u.getCellphoneNumber() ?? ""
                    email = u.getEmail()
                    password = u.getPassword()
                } else {
                    name = ""
                    number = ""
                    email = ""
                    password = ""
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
