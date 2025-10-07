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
                    Image("ProfileImageJim") // Placeholder for the profile picture
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
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        
                    }
                }
                .frame(width: 350, height: 150)
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 2)
                )
                .foregroundColor(.black)
            

                // Wallet Section
                VStack {
                    Text("Wallet: ")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .padding(.leading, 3)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text("1,000")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(.trailing, 3)
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                }
                .frame(width: 350, height: 70)
                .background(Color.white)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
                .foregroundColor(.black)
                

                // Icon Grid Section
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    // Orders
                    NavigationLink(destination: Text("Orders Screen")) {
                        ProfileIcon(iconName: "bag", label: "Orders")
                            .foregroundColor(.black)
                    }
                    
                    // Delivered
                    NavigationLink(destination: Text("Delivered Screen")) {
                        ProfileIcon(iconName: "checkmark.circle", label: "Delivered")
                            .foregroundColor(.black)
                    }

                    // Rates
                    NavigationLink(destination: Text("Rates Screen")) {
                        ProfileIcon(iconName: "star", label: "Rates")
                            .foregroundColor(.black)
                    }

                    // Wallet
                    NavigationLink(destination: CashInView()) {
                        ProfileIcon(iconName: "creditcard", label: "Wallet")
                            .foregroundColor(.black)
                    }

                    // Address
                    NavigationLink(destination: Text("Address Screen")) {
                        ProfileIcon(iconName: "map", label: "Address")
                            .foregroundColor(.black)
                    }

                    // Settings
                    NavigationLink(destination: SettingsView()) {
                        ProfileIcon(iconName: "gear", label: "Settings")
                            .foregroundColor(.black)
                    }

                    // FAQs
                    NavigationLink(destination: FAQsView()) {
                        ProfileIcon(iconName: "questionmark.circle", label: "FAQs")
                            .foregroundColor(.black)
                    }

                    // Logout
                    NavigationLink(destination: Text("Logout Screen")) {
                        ProfileIcon(iconName: "power", label: "Logout")
                            .foregroundColor(.black)
                    }
                    
                }
                .padding()
                
                // Fixed Bottom Navigation Bar with 4 icons (No search icon here anymore)
                VStack {
                    Spacer()
                    HStack {
                        NavigationLink(destination:  MainMenuScreen().navigationBarBackButtonHidden(true)) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black) // Black icon color
                                    .frame(maxWidth: .infinity) // Distribute space equally
                                    .padding(.vertical, 10)
                        }
                        NavigationLink(destination: CartMenuScreen().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black) // Black icon color
                                .frame(maxWidth: .infinity) // Distribute space equally
                                .padding(.vertical, 10)
                        }
                        Button(action: {
                                // Empty action for the Home button (won't navigate anywhere)
                        }) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black) // Black icon color
                                .frame(maxWidth: .infinity) // Distribute space equally
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(30) // Rounded edges for bottom tab
                    .shadow(radius: 10) // Add shadow for effect
                    .padding(.horizontal)
                }   


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
