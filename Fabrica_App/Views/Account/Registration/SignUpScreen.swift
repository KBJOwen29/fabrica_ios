import SwiftUI

struct SignUpScreen: View {
    @State private var email: String = ""
    @State private var navigateToPassword = false

    // Optional: Email validation (simple regex)
    private func isEmailValid(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("Sign up using your\nEmail Address")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("We’ll email you shortly for confirmation")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            TextField("samplemail123@gmail.com", text: $email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            NavigationLink(
                destination: PasswordScreen(email: email),
                isActive: $navigateToPassword
            ) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isEmailValid(email) ? Color.black : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal)
            .disabled(!isEmailValid(email))
            .simultaneousGesture(TapGesture().onEnded {
                let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
                if isEmailValid(trimmed) {
                    // email = "" // Uncomment to clear after navigation
                    navigateToPassword = true
                }
            })

            Spacer()
        }
        .padding()
    }
    
}

struct SignupScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
