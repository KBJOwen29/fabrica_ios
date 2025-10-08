import SwiftUI

struct SigninScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var navigateToMainMenu: Bool = false

    // Receive accounts from parent view
    var accounts: [Account]  // This will be the list of Account objects
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Sign in using your Email Address")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("samplemail123@gmail.com", text: $email)
                .textInputAutocapitalization(.never)  // Prevent email from auto-capitalizing
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

            // Show error message if the credentials are wrong
            if showError {
                Text("Account not found or incorrect password. Please check and try again.")
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal)
            }

            // Confirm Button - programmatic navigation
            Button(action: {
                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                print("Attempting to sign in with email: \(trimmedEmail)")

                // Check if the account exists and if the password matches
                if let account = accounts.first(where: {
                    $0.getEmail().trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == trimmedEmail
                }) {
                    print("Account found: \(account.getEmail())")

                    if account.verifyPassword(inputPassword: password) {
                        print("Password verified successfully.")
                        // If the email and password match, navigate to Main Menu
                        showError = false
                        navigateToMainMenu = true
                    } else {
                        print("Incorrect password.")
                        // Password is incorrect
                        showError = true
                    }
                } else {
                    print("Account with email \(trimmedEmail) not found.")
                    // Email doesn't exist in the accounts list
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
                EmptyView()  // This is a hidden navigation link that is activated programmatically
            }

            Spacer()
        }
    }
}

struct SigninScreen_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAccounts = [
            Account(email: "samplemail123@gmail.com", password: "password123"),
            Account(email: "admin@example.com", password: "admin123")  // Make sure this is included for testing
        ]
        
        SigninScreen(accounts: sampleAccounts)
    }
}
