//
//  SharedBottomTab.swift
//  Fabrica_App
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI

struct SharedBottomTab: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, cart, profile
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: { selectedTab = .home }) {
                    Image(systemName: "house")
                        .font(.title)
                        .padding()
                }
                Spacer()
                Button(action: { selectedTab = .cart }) {
                    Image(systemName: "cart")
                        .font(.title)
                        .padding()
                }
                Spacer()
                Button(action: { selectedTab = .profile }) {
                    Image(systemName: "person.circle")
                        .font(.title)
                        .padding()
                }
            }
            .frame(height: 60)
            .background(Color.gray.opacity(0.1))
        }
    }
}
