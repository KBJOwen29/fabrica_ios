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

    // Single alert controller for the whole screen
    @State private var activeAlert: SettingsAlert?

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
                                // Show confirmation (do not disable button)
                                activeAlert = .confirmProfile
                            }
                            .font(.subheadline.bold())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
                            .foregroundColor(.primary)
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
                                // Show confirmation
                                activeAlert = .confirmPassword
                            }
                            .font(.subheadline.bold())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
                            .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                // MARK: - Logout Button
                Button(action: {
                    activeAlert = .confirmLogout
                }) {
                    VStack {
                        Image(systemName: "arrow.left.to.line")
                            .font(.title)
                        Text("Logout")
                            .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
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
            // Single alert attached high in the view tree so it always presents
            .alert(item: $activeAlert) { alert in
                switch alert {
                case .confirmProfile:
                    return Alert(
                        title: Text("Confirm Save"),
                        message: Text("Save changes to your name and number?"),
                        primaryButton: .default(Text("Save"), action: performProfileSave),
                        secondaryButton: .cancel()
                    )
                case .confirmPassword:
                    return Alert(
                        title: Text("Confirm Save"),
                        message: Text("Save changes to your password?"),
                        primaryButton: .default(Text("Save"), action: performPasswordSave),
                        secondaryButton: .cancel()
                    )
                case .confirmLogout:
                    return Alert(
                        title: Text("Confirm Logout"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Logout"), action: performLogout),
                        secondaryButton: .cancel()
                    )
                case .saved(let message):
                    return Alert(
                        title: Text("Saved"),
                        message: Text(message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func performProfileSave() {
        guard let user = auth.currentUser else {
            activeAlert = .saved("No signed-in user.")
            return
        }
        user.setName(newName: name)
        user.setCellphoneNumber(newCellphone: number)
        repo.update(user)
        auth.updateCurrentUserIfSame(user)
        activeAlert = .saved("Your name and number have been saved.")
    }
    
    private func performPasswordSave() {
        guard let user = auth.currentUser else {
            activeAlert = .saved("No signed-in user.")
            return
        }
        user.setPassword(newPassword: password)
        repo.update(user)
        auth.updateCurrentUserIfSame(user)
        activeAlert = .saved("Your password has been saved.")
    }
    
    private func performLogout() {
        auth.signOut()
        // Optional: clear local fields
        name = ""
        number = ""
        email = ""
        password = ""
        activeAlert = .saved("You have been signed out.")
    }
}

// A single alert enum so only one .alert modifier is needed
private enum SettingsAlert: Identifiable {
    case confirmProfile
    case confirmPassword
    case confirmLogout
    case saved(String)
    
    var id: String {
        switch self {
        case .confirmProfile: return "confirmProfile"
        case .confirmPassword: return "confirmPassword"
        case .confirmLogout: return "confirmLogout"
        case .saved: return "saved"
        }
    }
}

#Preview {
    SettingsView()
}
