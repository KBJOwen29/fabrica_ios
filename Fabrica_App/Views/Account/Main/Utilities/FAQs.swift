//
//  FAQs.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/7/25.
//

import SwiftUI

struct FAQsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Account and Login
                    Section(header: Text("Account and Login")
                        .font(.title2)
                        .bold()) {
                        
                        FAQItem(
                            question: "Do I need an account to shop?",
                            answer: "Yes, creating an account helps us secure your orders and lets you track your purchase history."
                        )
                        
                        FAQItem(
                            question: "I forgot my password, what should I do?",
                            answer: "Tap “Forgot Password” on the login screen and follow the steps to reset your password via email."
                        )
                        
                        FAQItem(
                            question: "How do I verify my email?",
                            answer: "After signing up, check your inbox for a verification email and click the link to activate your account."
                        )
                    }
                    
                    // MARK: - Shopping & Categories
                    Section(header: Text("Shopping & Categories")
                        .font(.title2)
                        .bold()) {
                        
                        FAQItem(
                            question: "What products are available?",
                            answer: "We currently offer caps, men’s wear, women’s wear, and shoes."
                        )
                        
                        FAQItem(
                            question: "How do I find products?",
                            answer: "Browse categories on the main menu or use the search function to quickly find items."
                        )
                        
                        FAQItem(
                            question: "Can I see product details before buying?",
                            answer: "Yes, just tap any product to view details like price, and description."
                        )
                    }
                    
                    // MARK: - Shipping & Delivery
                    Section(header: Text("Shipping & Delivery")
                        .font(.title2)
                        .bold()) {
                        
                        FAQItem(
                            question: "How long does delivery take?",
                            answer: "Standard delivery usually takes 3–7 business days, depending on your location."
                        )
                        
                        FAQItem(
                            question: "Do you offer free shipping?",
                            answer: "Free shipping may apply on orders in a Limited Offer."
                        )
                    }
                    
                    // MARK: - Support
                    Section(header: Text("Support")
                        .font(.title2)
                        .bold()) {
                        
                        FAQItem(
                            question: "How do I contact customer support?",
                            answer: "You can reach out via the Help & Support option in your profile or email us at support@email.com."
                        )
                    }
                    
                }
                .padding()
            }
            .navigationTitle("FAQs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Reusable FAQ Item View
struct FAQItem: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Q: \(question)")
                .font(.headline)
            Text("A: \(answer)")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    FAQsView()
}
