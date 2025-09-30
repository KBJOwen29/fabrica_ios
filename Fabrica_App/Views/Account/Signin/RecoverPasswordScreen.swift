import SwiftUI

struct RecoverPasswordScreen: View {
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    var accounts: [String]
    @State private var showError: Bool = false
    @State private var navigateToSignin: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Recover your Password\nwith your Email")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            TextField("samplemail123@gmail.com", text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)
            
            SecureField("New Password", text: $newPassword)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)
            
            if showError {
                Text("Account not found or passwords do not match.")
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal)
            }

            NavigationLink(destination: SigninScreen(accounts: accounts), isActive: $navigateToSignin) {
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
                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                if accounts.contains(trimmedEmail) && newPassword == confirmPassword && !newPassword.isEmpty {
                    showError = false
                    navigateToSignin = true
                } else {
                    showError = true
                }
            })
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct RecoverPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordScreen(accounts: ["samplemail123@gmail.com", "another@email.com"])
    }
}
