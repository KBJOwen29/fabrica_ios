//
//  AuthService.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/24/25.
//

import Foundation
import Combine

public final class AuthService: ObservableObject {
    @Published public private(set) var currentUser: Account? = nil
    @Published public var authError: String? = nil

    private let repository: AccountsRepositoryProtocol

    public init(repository: AccountsRepositoryProtocol = AccountsRepository.shared) {
        self.repository = repository
    }

    @discardableResult
    public func signIn(email: String, password: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let acct = repository.findAccount(matchingEmail: trimmed) else {
            authError = "Account not found"
            return false
        }
        if acct.verifyPassword(inputPassword: password) {
            currentUser = acct
            authError = nil
            return true
        } else {
            authError = "Incorrect password"
            return false
        }
    }

    @discardableResult
    public func signUp(email: String, password: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty, !password.isEmpty else {
            authError = "Email or password cannot be empty"
            return false
        }
        if repository.findAccount(matchingEmail: trimmed) != nil {
            authError = "Account already exists"
            return false
        }
        let new = Account(email: trimmed, password: password)
        repository.add(new)
        authError = nil
        return true
    }

    public func signOut() {
        currentUser = nil
    }

    @discardableResult
    public func recoverPassword(email: String, newPassword: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let acct = repository.findAccount(matchingEmail: trimmed) else {
            authError = "Account not found"
            return false
        }
        acct.setPassword(newPassword: newPassword)
        authError = nil
        return true
    }
}
