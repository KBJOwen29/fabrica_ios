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

    // Logic-only wiring
    @ObservedObject private var auth = AuthService.shared
    private let repo = AccountsRepository.shared

    // Alerts
    @State private var showConfirmTopUp = false
    @State private var showTopUpSuccess = false
    @State private var showTopUpError = false
    
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
                    // Validate before asking to confirm
                    guard auth.currentUser != nil else {
                        showTopUpError = true
                        return
                    }
                    let value = Double(amount.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                    guard value > 0 else {
                        showTopUpError = true
                        return
                    }
                    showConfirmTopUp = true
                    // Keep existing log
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

            // Confirm cash-in alert
            .alert("Confirm cash in", isPresented: $showConfirmTopUp) {
                Button("Cancel", role: .cancel) {}
                Button("Confirm") {
                    guard let user = auth.currentUser else { return }
                    let value = Double(amount.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                    user.addFunds(amount: value)
                    repo.update(user)
                    auth.updateCurrentUserIfSame(user)
                    showTopUpSuccess = true
                }
            } message: {
                Text("Proceed to add funds to your wallet?")
            }

            // Success / error alerts
            .alert("Cash in successful", isPresented: $showTopUpSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your wallet has been updated.")
            }
            .alert("Unable to proceed", isPresented: $showTopUpError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please sign in and enter a valid amount.")
            }
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
