import Foundation
import UIKit

// Class representing a User with encapsulated properties
public class Account {
   
    private var email: String
    private var password: String
    private var name: String?
    private var cellphoneNumber: String?
    private var wallet: Double
    
    // NEW: Raw image data for profile photo (optional)
    private var profileImageData: Data?
    
    // Public initializer to create a new User instance with only email and password
    public init(email: String, password: String) {
        self.email = email
        self.password = password
        self.wallet = 1000 // Default wallet balance is 1000
    }
    
    // Static method to get default admin account (for testing or bypassing registration)
    public static func getDefaultAdmin() -> Account {
        return Account(email: "jimowen@gmail.com", password: "admin123")  // You can change these values
    }
    
    // Email
    public func getEmail() -> String { email }
    public func setEmail(newEmail: String) { email = newEmail }
    
    // Password
    public func getPassword() -> String { password }
    public func setPassword(newPassword: String) { password = newPassword }
    
    // Name
    public func getName() -> String? { name }
    public func setName(newName: String?) { name = newName }
    
    // Cellphone Number
    public func getCellphoneNumber() -> String? { cellphoneNumber }
    public func setCellphoneNumber(newCellphone: String?) { cellphoneNumber = newCellphone }
    
    // Wallet
    public func getWalletBalance() -> Double { wallet }
    public func setWalletBalance(newWalletBalance: Double) { wallet = newWalletBalance }
    
    // Profile Image (Data)
    public func setProfileImage(data: Data?) {
        profileImageData = data
    }
    
    public func getProfileImageData() -> Data? {
        profileImageData
    }
    
    // Convenience: UIImage for SwiftUI Image(uiImage:)
    public func getProfileUIImage() -> UIImage? {
        guard let d = profileImageData else { return nil }
        return UIImage(data: d)
    }
    
    // Public method to add funds to the wallet
    public func addFunds(amount: Double) {
        wallet += amount
    }
    
    // Public method to subtract funds from the wallet
    public func subtractFunds(amount: Double) {
        if wallet >= amount {
            wallet -= amount
        } else {
            print("Insufficient funds")
        }
    }
    
    // Method to update the user's details
    public func updateDetails(name: String?, cellphone: String?, walletBalance: Double?) {
        if let name = name { self.name = name }
        if let cellphone = cellphone { self.cellphoneNumber = cellphone }
        if let walletBalance = walletBalance { self.wallet = walletBalance }
    }
    
    // Password validation
    public func verifyPassword(inputPassword: String) -> Bool {
        return inputPassword == password
    }
}
