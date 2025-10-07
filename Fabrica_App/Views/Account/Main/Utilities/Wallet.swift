//
//  Wallet.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/7/25.
//

import SwiftUI

struct CashInView: View {
    @State private var pageTitle: String = "Cash In"
    @State private var amount: String = "0"
    
    // Keypad layout
    let buttons: [[String]] = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["0", ".", "⌫"]
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                // MARK: - Editable Title Field
                TextField("Title", text: $pageTitle)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .cornerRadius(8)
                
                // MARK: - Amount Display (TextField)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Amount:")
                        .font(.headline)
                        .padding(.leading)
                    
                    TextField("", text: $amount)
                        .multilineTextAlignment(.trailing)
                        .font(.title)
                        .padding(.trailing)
                        .keyboardType(.decimalPad)
                }
                .frame(width: 350, height: 100)
                .background(Color.white)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
                
                // MARK: - Keypad
                VStack(spacing: 16) {
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 16) {
                            ForEach(row, id: \.self) { label in
                                Button(action: {
                                    handleTap(label)
                                }) {
                                    Text(label)
                                        .font(.title2)
                                        .frame(width: 90, height: 90)
                                        .background(Color(UIColor.systemGray5))
                                        .clipShape(Circle())
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // MARK: - Confirm Button
                Button(action: {
                    print("Title: \(pageTitle), Amount: \(amount)")
                }) {
                    Text("Confirm")
                        .font(.body.bold())
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }
                .foregroundColor(.primary)
                
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
        }
    }
    
    // MARK: - Handle Keypad Input
    private func handleTap(_ label: String) {
        switch label {
        case "⌫":
            if amount.count > 1 {
                amount.removeLast()
            } else {
                amount = "0"
            }
        case ".":
            if !amount.contains(".") {
                amount.append(".")
            }
        default:
            if amount == "0" {
                amount = label
            } else {
                amount.append(label)
            }
        }
    }
}

#Preview {
    CashInView()
}
