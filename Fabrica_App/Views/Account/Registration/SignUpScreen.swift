import SwiftUI

struct SignUpScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToVerification = false

    // Optional: Email validation (simple regex)
    private func isEmailValid(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign up using your\nEmail Address")
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text("We’ll email you shortly for confirmation")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            TextField("samplemail123@gmail.com", text: $email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Text("Create a Password")
                .font(.system(size: 18, weight: .bold))
            
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

            // Navigation Link to Email Verification Screen
            NavigationLink(
                destination: EmailVerification().navigationBarBackButtonHidden(true),
                isActive: $navigateToVerification
            ) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isEmailValid(email) ? Color.black : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal)
            .disabled(!isEmailValid(email)) // Disable button if email is not valid
            .onTapGesture {
                // Only trigger navigation if the email is valid
                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                if isEmailValid(trimmedEmail) {
                    navigateToVerification = true
                }
            }

            Spacer()
        }
        .padding()
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpScreen()
        }
    }
}
