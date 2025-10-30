//
//  AccountStorageService.swift
//  Fabrica_App
//
//  Created by STUDENT on 10/30/25.
//

import Foundation

// DTO for persistence (Codable)
private struct AccountDTO: Codable {
    let email: String
    let password: String
    let name: String?
    let cellphoneNumber: String?
    let wallet: Double
}

final class AccountStorageService {
    static let shared = AccountStorageService()
    private init() {}

    private let storageKey = "accounts_storage_v1"

    // Load accounts from UserDefaults (JSON)
    func loadAccounts() -> [Account] {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let dtos = try? JSONDecoder().decode([AccountDTO].self, from: data)
        else {
            return []
        }
        return dtos.map { dto in
            let acc = Account(email: dto.email, password: dto.password)
            acc.setName(newName: dto.name)
            acc.setCellphoneNumber(newCellphone: dto.cellphoneNumber)
            acc.setWalletBalance(newWalletBalance: dto.wallet)
            return acc
        }
    }

    // Save accounts to UserDefaults (JSON)
    func saveAccounts(_ accounts: [Account]) {
        let dtos: [AccountDTO] = accounts.map { acc in
            AccountDTO(
                email: acc.getEmail(),
                password: acc.getPassword(),
                name: acc.getName(),
                cellphoneNumber: acc.getCellphoneNumber(),
                wallet: acc.getWalletBalance()
            )
        }
        if let data = try? JSONEncoder().encode(dtos) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
