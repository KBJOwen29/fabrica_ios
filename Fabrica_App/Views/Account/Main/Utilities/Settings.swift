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
    @State private var email: String = "samplemail123@email.com"
    @State private var password: String = "password"
    
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
                                // Save profile info action
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
                            .disabled(true) // email field is not editable in image
                        
                        Text("Password")
                            .font(.subheadline)
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            Spacer()
                            Button("Save") {
                                // Save account info action
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
                    // Logout action
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
        }
    }
}

#Preview {
    SettingsView()
}
