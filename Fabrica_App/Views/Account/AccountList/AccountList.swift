import SwiftUI

struct AccountList: View {
    @Binding var accounts: [String]

    var body: some View {
        VStack(spacing: 30) {
            Text("Registered Accounts")
                .font(.headline)
                .multilineTextAlignment(.center)

            if accounts.isEmpty {
                Text("No accounts registered yet.")
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(accounts, id: \.self) { acct in
                        Text(acct)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Account List")
    }
}
