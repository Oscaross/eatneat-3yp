//
//  LocalFoodbankAPI.swift
//  EatNeat
//
//  Created by Oscar Horner on 31/10/2025.
//

import Foundation
import SwiftUI

struct LocalFoodbankAPI {
    private var locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    public func pollFoodbankNeeds() async throws -> [FoodbankNeeds] {
        // endpoint creation with location data
        let url = buildAPIEndpoint()
        
        if url == nil {
            return [] // no location = no donation candidates
        }
        
        var request = URLRequest(url: URL(string: url!)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request) // fire request
        
        // verify the API call is a successful status code, if not, throw
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([FoodbankNeeds].self, from: data)
    }
    
    private func buildAPIEndpoint() -> String? {
        // if lat or long is not present then no API call can be made so return nil
        if (locationManager.latitude == nil || locationManager.longitude == nil) { return nil }
        
        let lat = locationManager.latitude!
        let long = locationManager.longitude!
        
        return "https://www.givefood.org.uk/api/2/foodbanks/search/?lat_lng=" + lat.formatted() + "," + long.formatted()
    }
}
