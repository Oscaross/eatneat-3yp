//
//  Preference.swift
//  EatNeat
//
//  Created by Oscar Horner on 06/02/2026.
//
// Represents a togglable preference in the app, such as "Show expired items". The key is used for persistence and the default value is used when no value has been set yet.

import Foundation

struct Preference<Value> {
    let key: String
    let defaultValue: Value
}
