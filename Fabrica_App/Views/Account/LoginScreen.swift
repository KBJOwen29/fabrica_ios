import SwiftUI

struct LoginScreen: View {
    @State private var accounts: [String] = []

    var body: some View {
        NavigationView {
            ZStack {
                Image("Screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Start shopping by")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    Text("logging in or signing up")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    Text("Step into the world of shopping")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.horizontal, 20)
                    Text("and convenience")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    Spacer()
                    NavigationLink(destination: SigninScreen(accounts: accounts)) {
                        Text("Sign in with Email")
                            .frame(maxWidth: 270)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    HStack {
                        Text("Don’t have an Account?")
                        NavigationLink(destination: SignUpScreen()) {
                            Text("Register")
                                .foregroundColor(.blue)
                        }
                    }

                }
                .padding(.top, 10)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
