//
//  AccountsRepository.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/24/25.
//

import Foundation
import Combine

public protocol AccountsRepositoryProtocol {
    func add(_ account: Account)
    func findAccount(matchingEmail email: String) -> Account?
    var allAccounts: [Account] { get }
}

public final class AccountsRepository: ObservableObject, AccountsRepositoryProtocol {
    public static let shared = AccountsRepository()

    @Published private(set) var accounts: [Account] = []

    private init() {
        // Seed some known accounts for development/testing
        accounts = [
            Account(email: "samplemail123@gmail.com", password: "password123"),
            Account.getDefaultAdmin()
        ]
    }

    public var allAccounts: [Account] { accounts }

    public func add(_ account: Account) {
        // Simple dedupe by email
        let trimmed = account.getEmail().trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if findAccount(matchingEmail: trimmed) == nil {
            accounts.append(account)
            // TODO: persist to disk (UserDefaults/Keychain) via a StorageService
        } else {
            // optionally update existing account or ignore
            print("AccountsRepository: account already exists for \(trimmed)")
        }
    }

    public func findAccount(matchingEmail email: String) -> Account? {
        let target = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return accounts.first {
            $0.getEmail().trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == target
        }
    }
}
