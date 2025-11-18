//
//  FoodbankNeeds.swift
//  EatNeat
//
//  Created by Oscar Horner on 01/11/2025.
//
// Models the needs of a foodbank (the list of items, foodbank name, instructions, coordinates...) as a result of querying the Give Food API.

import Foundation

struct FoodbankNeeds: Decodable {
    let id: String
    let name: String
    let phone: String?
    let email: String?
    let address: String?
    let postcode: String?
    let latLng: String?
    let distance: Double?
    let needs: String?
    let homepage: String?

    // Match JSON key paths and handle nested fields (like "urls.homepage" and "needs.needs")
    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, address, postcode, latLng = "lat_lng", distance = "distance_m"
        case needs, urls
    }
    
    enum NeedsKeys: String, CodingKey {
        case needs
    }
    
    enum UrlsKeys: String, CodingKey {
        case homepage
    }
    
    // Custom decoding for nested structures
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        phone = try? container.decode(String.self, forKey: .phone)
        email = try? container.decode(String.self, forKey: .email)
        address = try? container.decode(String.self, forKey: .address)
        postcode = try? container.decode(String.self, forKey: .postcode)
        latLng = try? container.decode(String.self, forKey: .latLng)
        distance = try? container.decode(Double.self, forKey: .distance)
        
        // Decode nested "needs" to "needs"
        if let needsContainer = try? container.nestedContainer(keyedBy: NeedsKeys.self, forKey: .needs) {
            needs = try? needsContainer.decode(String.self, forKey: .needs)
        } else {
            needs = nil
        }
        
        // Decode nested "urls" to "homepage"
        if let urlsContainer = try? container.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls) {
            homepage = try? urlsContainer.decode(String.self, forKey: .homepage)
        } else {
            homepage = nil
        }
    }
    
    func mapNeedsToPantry() -> [String: [PantryItem]] {
        guard let needs = needs else { return [:] }

        let items = needs
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }

        var map: [String: [PantryItem]] = [:]
        for need in items {
            map[need] = [PantryItem(quantity: 1, name: "Spaghetti", category: Category.pastaRiceAndNoodles)] // TODO: update to include actual needs
        }
        return map
    }
}

