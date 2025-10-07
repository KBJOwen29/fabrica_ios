import Foundation

// MARK: - Account Struct
struct Account {
    let email: String
    private let hashedPassword: String

    // Initializer
    init(email: String, password: String) {
        self.email = email
        self.hashedPassword = Account.hash(password: password)
    }

    // Verify if the provided password matches the hashed password
    func verifyPassword(_ password: String) -> Bool {
        return Account.hash(password: password) == hashedPassword
    }

    // Hashing function (simple example, replace with a secure hashing algorithm in production)
    private static func hash(password: String) -> String {
        return String(password.reversed()) // Simple, for demonstration only
    }
}

// MARK: - AccountManager Class to Manage Accounts
class AccountManager {
    private var accounts: [String: Account] = [:] // Using email as the key

    // Function to add a new account
    func addAccount(email: String, password: String) -> String {
        if accounts[email] != nil {
            return "Account with this email already exists."
        }
        
        let newAccount = Account(email: email, password: password)
        accounts[email] = newAccount
        return "Account created successfully."
    }

    // Function to verify a user's credentials
    func verifyAccount(email: String, password: String) -> Bool {
        guard let account = accounts[email] else {
            return false
        }
        return account.verifyPassword(password)
    }
}

// Example Usage:
// let accountManager = AccountManager()
// print(accountManager.addAccount(email: "test@example.com", password: "securePassword"))
// let isValid = accountManager.verifyAccount(email: "test@example.com", password: "securePassword")
