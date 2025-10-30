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

    private let storage = AccountStorageService.shared

    private init() {
        // Load from storage first
        let stored = storage.loadAccounts()
        if stored.isEmpty {
            // Seed known accounts for development/testing if none stored
            accounts = [
                Account(email: "samplemail123@gmail.com", password: "password123"),
                Account.getDefaultAdmin()
            ]
            storage.saveAccounts(accounts)
        } else {
            accounts = stored
        }
    }

    public var allAccounts: [Account] { accounts }

    public func add(_ account: Account) {
        // Simple dedupe by email
        let trimmed = account.getEmail().trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if findAccount(matchingEmail: trimmed) == nil {
            accounts.append(account)
            storage.saveAccounts(accounts) // persist
        } else {
            print("AccountsRepository: account already exists for \(trimmed)")
        }
    }

    public func findAccount(matchingEmail email: String) -> Account? {
        let target = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return accounts.first {
            $0.getEmail().trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == target
        }
    }

    // Update existing account (replace by email). If absent, append it.
    public func update(_ account: Account) {
        let target = account.getEmail().trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let idx = accounts.firstIndex(where: {
            $0.getEmail().trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == target
        }) {
            accounts[idx] = account
        } else {
            accounts.append(account)
        }
        storage.saveAccounts(accounts) // persist
    }
}
