import SwiftUI

struct PasswordScreen: View {
    var email: String
    @State private var password: String = ""
    @State private var navigateToVerification = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Create a Password")
                .font(.headline)
            
            Text("Protect your account by creating a secure password")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            // Displaying the email for context (optional)
            Text("For: \(email)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            NavigationLink(
                destination: EmailVerification(),
                isActive: $navigateToVerification
            ) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal)
            .simultaneousGesture(TapGesture().onEnded {
                let trimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    navigateToVerification = true
                }
            })
        }
        .padding()
    }
}
