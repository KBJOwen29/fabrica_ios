import SwiftUI

struct SigninScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var navigateToMainMenu: Bool = false
    // Receive accounts from parent view
    var accounts: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Sign in using your Email Address")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            TextField("samplemail123@gmail.com", text: $email)
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
            
            // Show error if email not found
            if showError {
                Text("Account not found. Please register first.")
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal)
            }
            
            // Confirm Button - programmatic navigation
            NavigationLink(destination: MainMenuScreen(), isActive: $navigateToMainMenu) {
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
            .simultaneousGesture(TapGesture().onEnded {
                let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
                if accounts.contains(trimmed) {
                    showError = false
                    navigateToMainMenu = true
                } else {
                    showError = true
                }
            })
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct SigninScreen_Previews: PreviewProvider {
    static var previews: some View {
        SigninScreen(accounts: ["samplemail123@gmail.com", "another@email.com"])
    }
}
