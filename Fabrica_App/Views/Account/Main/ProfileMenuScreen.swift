//
//  ProfileMenuScreen.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/7/25.
//

import SwiftUI

struct ProfileMenuScreen: View {
    @State private var navigateToOrders = false
    @State private var navigateToDelivered = false
    @State private var navigateToWallet = false
    @State private var navigateToRates = false
    @State private var navigateToAddress = false
    @State private var navigateToSettings = false
    @State private var navigateToFAQs = false
    @State private var navigateToLogout = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Profile Section
                HStack(spacing: 10) {
                    // Profile Picture
                    Image(systemName: "person.circle.fill") // Placeholder for the profile picture
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.bottom, 10)
                    VStack{
                        
                        // User's Name and Contact
                        Text("Jim Owen K. Bognalbal")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("0968-719-0116")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Wallet Section
                        
                    }
                }
                .padding()
                
                VStack {
                    Text("Wallet: ")
                        .font(.headline)
                        .frame(width: .infinity, alignment: .leading)
                    Text("1,000")
                        .font(.title3)
                        .foregroundColor(.green)
                        .frame(width: .infinity, alignment: .trailing)
                }
                

                // Icon Grid Section
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    // Orders
                    NavigationLink(destination: Text("Orders Screen")) {
                        ProfileIcon(iconName: "box", label: "Orders")
                    }
                    
                    // Delivered
                    NavigationLink(destination: Text("Delivered Screen")) {
                        ProfileIcon(iconName: "checkmark.circle", label: "Delivered")
                    }

                    // Rates
                    NavigationLink(destination: Text("Rates Screen")) {
                        ProfileIcon(iconName: "star", label: "Rates")
                    }

                    // Wallet
                    NavigationLink(destination: Text("Wallet Screen")) {
                        ProfileIcon(iconName: "creditcard", label: "Wallet")
                    }

                    // Address
                    NavigationLink(destination: Text("Address Screen")) {
                        ProfileIcon(iconName: "map", label: "Address")
                    }

                    // Settings
                    NavigationLink(destination: Text("Settings Screen")) {
                        ProfileIcon(iconName: "gear", label: "Settings")
                    }

                    // FAQs
                    NavigationLink(destination: Text("FAQs Screen")) {
                        ProfileIcon(iconName: "questionmark.circle", label: "FAQs")
                    }

                    // Logout
                    NavigationLink(destination: Text("Logout Screen")) {
                        ProfileIcon(iconName: "power", label: "Logout")
                    }
                }
                .padding()

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct ProfileIcon: View {
    var iconName: String
    var label: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName) // Placeholder for your custom icons
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()
            Text(label)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenuScreen()
    }
}
