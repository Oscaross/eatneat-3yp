//
//  SaveManager.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/11/2025.
//
// Save and load data for the app. Any object that conforms to Codable can use the SaveManager.

import Foundation

final class SaveManager {
    static let shared = SaveManager()
    private init() {}

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private func url(forKey key: String) -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("\(key).json")
    }
    
    // MARK: - Save
    func save<T: Codable>(_ object: T, forKey key: String) throws {
        let data = try encoder.encode(object)
        let url = url(forKey: key)
        try data.write(to: url, options: .atomic)
    }

    // MARK: - Load
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T {
        let url = url(forKey: key)
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Delete
    func delete(forKey key: String) throws {
        let url = url(forKey: key)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}
