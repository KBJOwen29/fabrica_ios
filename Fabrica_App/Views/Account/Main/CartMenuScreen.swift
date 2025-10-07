//
//  CartMenuScreen.swift
//  Fabrica_App
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI

struct CartMenuScreen: View {
    @State private var isItem1Selected = true
    @State private var isItem2Selected = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // Cart Title
            Text("My Cart")
                .font(.headline)
                .padding(.horizontal)
            
            // Cart Item 1
            CartItemView(isSelected: $isItem1Selected,
                         name: "Round Neck Green Shirt",
                         price: 599,
                         imageName: "tshirt.fill")
            
            // Cart Item 2
            CartItemView(isSelected: $isItem2Selected,
                         name: "Nike Pegasus 41",
                         price: 4437,
                         oldPrice: 7995,
                         imageName: "cart.fill",
                         discount: "40% Off")
            
            // Subtotal
            HStack {
                Text("Subtotal:")
                    .bold()
                Spacer()
                Text("₱\(isItem1Selected ? 599 : 0)")
                    .bold()
            }
            .padding()
            
            // Confirm Button
            Button(action: {
                // Confirm action
            }) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
            }
            .padding(.top)
            
            Spacer()
            
            
        }
        .padding(.bottom, 20)
        
    }
}

struct CartItemView: View {
    @Binding var isSelected: Bool
    let name: String
    let price: Int
    let oldPrice: Int?
    let imageName: String
    let discount: String?
    
    init(isSelected: Binding<Bool>, name: String, price: Int, oldPrice: Int? = nil, imageName: String, discount: String? = nil) {
        self._isSelected = isSelected
        self.name = name
        self.price = price
        self.oldPrice = oldPrice
        self.imageName = imageName
        self.discount = discount
    }
    
    var body: some View {
        HStack {
            Toggle("", isOn: $isSelected)
                .labelsHidden()
                .frame(width: 30)
            
            Image(systemName: imageName)
                .resizable()
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(name)
                    .bold()
                if let discount = discount {
                    Text(discount)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                HStack {
                    Text("1")
                    Spacer()
                    if let old = oldPrice {
                        Text("₱\(old)")
                            .strikethrough()
                    }
                    Text("₱\(price)")
                        .bold()
                }
            }
            
            Spacer()
            Image(systemName: "trash")
        }
        .padding(.horizontal)
        
        
    }
}

struct CartMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        CartMenuScreen()
    }
}
