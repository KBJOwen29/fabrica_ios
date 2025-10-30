import SwiftUI

struct SigninScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var navigateToMainMenu: Bool = false

    // Receive accounts from parent view (kept for backwards compatibility/testing)
    var accounts: [Account]  // This will be the list of Account objects

    // Use shared AuthService
    @ObservedObject private var auth = AuthService.shared

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Sign in using your Email Address")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("samplemail123@gmail.com", text: $email)
                .textInputAutocapitalization(.never)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)

            HStack {
                Spacer()
                NavigationLink(destination: RecoverPasswordScreen(accounts: accounts)) {
                    Text("Forgot Password?")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                        .padding(.trailing)
                }
            }

            if showError || auth.authError != nil {
                Text(auth.authError ?? "Account not found or incorrect password. Please check and try again.")
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal)
            }

            // Confirm Button - programmatic navigation using AuthService
            Button(action: {
                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let success = auth.signIn(email: trimmedEmail, password: password)
                if success {
                    showError = false
                    navigateToMainMenu = true
                } else {
                    showError = true
                }
            }) {
                Text("Confirm")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
            }
            .padding(.top)

            // Navigate to Main Menu screen only if login is successful
            NavigationLink(
                destination: MainMenuScreen().navigationBarBackButtonHidden(true),
                isActive: $navigateToMainMenu
            ) {
                EmptyView()
            }

            Spacer()
        }
    }
}

struct SigninScreen_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAccounts = [
            Account(email: "samplemail123@gmail.com", password: "password123"),
            Account(email: "jimowen@gmail.com", password: "admin123")
        ]
        SigninScreen(accounts: sampleAccounts)
    }
}
