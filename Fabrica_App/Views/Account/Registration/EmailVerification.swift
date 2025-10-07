import SwiftUI

struct EmailVerification: View {
    var body: some View {
        VStack(spacing: 30) {
            // Checkmark image
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            // Title and Subheading
            Text("Verify Email")
                .font(.headline)
            
            Text("Click 'Confirm' to verify your email and complete the signup process. Get ready to start shopping!")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            // Confirm button
            NavigationLink(destination: LoginScreen().navigationBarBackButtonHidden(true)) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
