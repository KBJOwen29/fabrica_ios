//
//  PhilippinesData.swift
//  Fabrica_App
//
//  Created by STUDENT on 11/18/25.
//

import Foundation

// Data models expected in the JSON bundle. Keep them simple and Codable.

struct PHRegion: Codable, Identifiable, Equatable {
    var id: String { code }
    let code: String
    let name: String
    let provinces: [PHProvince]

    init(code: String, name: String, provinces: [PHProvince]) {
        self.code = code
        self.name = name
        self.provinces = provinces
    }
}

struct PHProvince: Codable, Identifiable, Equatable {
    var id: String { code }
    let code: String
    let name: String
    let cities: [PHCity]
}

struct PHCity: Codable, Identifiable, Equatable {
    var id: String { code }
    let code: String
    let name: String
    let barangays: [PHBarangay]
}

struct PHBarangay: Codable, Identifiable, Equatable {
    var id: String { code }
    let code: String
    let name: String
    let postalCode: String?
}
