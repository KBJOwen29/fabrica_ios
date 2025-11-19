//
//  Settings.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/7/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var auth = AuthService.shared
    private let repo = AccountsRepository.shared

    @State private var name: String = ""
    @State private var number: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    // Alerts
    @State private var activeAlert: SettingsAlert?

    // Present LoginScreen when user logs out
    @State private var showSignIn = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Profile fields...
                VStack(spacing: 12) {
                    TextField("Name", text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
                    TextField("Cellphone Number", text: $number)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
                    
                    Button("Save Profile") { activeAlert = .confirmProfile }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    TextField("Email", text: $email)
                        .disabled(true)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
                    
                    Button("Save Password") { activeAlert = .confirmPassword }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    
                }
                .foregroundColor(.primary)

                // Action buttons...
                VStack(spacing: 10) {


                    Button(role: .destructive) { activeAlert = .confirmLogout } label: {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
                }
                .foregroundColor(.primary)

            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let user = auth.currentUser {
                    name = user.getName() ?? ""
                    number = user.getCellphoneNumber() ?? ""
                    email = user.getEmail()
                    password = user.getPassword()
                }
                // Ensure the sign-in shows if there is no user on entry
                showSignIn = (auth.currentUser == nil)
            }
            .onReceive(auth.$currentUser) { user in
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
                // Trigger sign-in if user becomes nil
                showSignIn = (user == nil)
            }
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
        // Present LoginScreen when signed out
        .fullScreenCover(isPresented: $showSignIn) {
            LoginScreen().navigationBarBackButtonHidden(true)
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
        // Clear local fields
        name = ""
        number = ""
        email = ""
        password = ""
        // Immediately show sign-in
        showSignIn = true
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
