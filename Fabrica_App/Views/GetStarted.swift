import SwiftUI

struct GetStarted: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background image - Full screen coverage
                Image("Image") 
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)  // Ensures the image covers the entire screen

                // Overlay content
                VStack {
                    Spacer(minLength: 120)  // Adjust to give enough space from top for text
                    Spacer()

                    // Title Text
                    Text("Hello, Shop With Confidence")
                        .padding(.vertical, 10) // Add paddind to make the text seperated
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)  // Make sure the text stands out
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)  // Add padding to prevent text touching screen edges

                    // Subtitle Text
                    Text("Quality products, exceptional\nservice, every time")
                        .font(.subheadline)
                        .foregroundColor(.black)  // Ensure text is visible over the image
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.horizontal, 20)  // Same horizontal padding

                    Spacer()

                    // Get Started Button
                    NavigationLink(destination: LoginScreen()) {
                        Text("Get Started")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 40)  // Space from the bottom of the screen
                }
                .padding(.top, 10)  // Additional top padding if necessary
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct GetStarted_Preview: PreviewProvider {
    static var previews: some View {
        GetStarted()
    }
}


