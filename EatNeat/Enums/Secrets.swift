//
//  Secrets.swift
//  EatNeat
//
//  Created by Oscar Horner on 30/11/2025.
//

import Foundation

enum Secrets {
    static var openAIApiKey: String {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [String: Any],
            let key = dict["OPENAI_API_KEY"] as? String
        else {
            fatalError("OPENAI_API_KEY missing from Secrets.plist")
        }
        return key
    }
}
