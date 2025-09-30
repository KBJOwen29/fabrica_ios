//
//  ProfileScreen.swift
//  Fabrica_App
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI

struct ProfileMenuScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            // Profile Header
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading) {
                    Text("Jim Owen K. Bognalbal")
                        .bold()
                    Text("Wallet:")
                    Text("₱1,000")
                        .font(.title)
                        .bold()
                }
                .padding(.leading)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke())
            .padding(.horizontal)
            
            // Icons for Payment, Packing, Shipping, Rating
            HStack(spacing: 30) {
                ProfileIconView(icon: "creditcard", label: "Payment")
                ProfileIconView(icon: "cube.box.fill", label: "Packing")
                ProfileIconView(icon: "clock.arrow.circlepath", label: "Shipping")
                ProfileIconView(icon: "star.fill", label: "Rating")
            }
            
            Spacer()
            
            
        }
        .padding(.bottom, 20)
    }
}

struct ProfileIconView: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 30, height: 30)
            Text(label)
                .font(.caption)
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenuScreen()
    }
}
