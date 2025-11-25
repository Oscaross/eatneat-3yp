//
//  FoodbankInfoView.swift
//  EatNeat
//
//  Created by Oscar Horner on 09/11/2025.
//

import SwiftUI
import MapKit

struct FoodbankInfoView: View {
    var foodbank: FoodbankNeeds
    var currSelectedNeeds: Set<Int> = []

    @State private var isFavourite = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.38, longitude: -1.56),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.04) {

                    // MARK: Title Row
                    HStack(spacing: 20) {

                        // Favourite star
                        Button { isFavourite.toggle() } label: {
                            Image(systemName: isFavourite ? "star.fill" : "star")
                                .foregroundColor(isFavourite ? .yellow : .gray)
                                .font(.system(size: 22))
                        }
                        
                        Spacer()

                        Text(foodbank.name)
                            .font(.headline)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        // Report icon
                        Button { print("Report tapped") } label: {
                            Image(systemName: "flag")
                                .font(.system(size: 22))
                                .foregroundColor(.red)
                        }
                    }

                    // MARK: Details Block — Address, Distance, Phone, Email
                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.008) {

                        if let address = foodbank.address {
                            let singleLine = address
                                .components(separatedBy: .newlines)
                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                .filter { !$0.isEmpty }
                                .joined(separator: ", ")

                            HStack(spacing: UIScreen.main.bounds.width * 0.02) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.secondary)

                                Text(singleLine)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                            }
                        }


                        HStack(spacing: UIScreen.main.bounds.width * 0.02) {
                            Image(systemName: "location")
                                .foregroundColor(.secondary)

                            Text(foodbank.formattedDistance())
                        }
                    

                        if let phone = foodbank.phone,
                           let phoneURL = URL(string: "tel://\(phone.filter { $0.isNumber })") {

                            HStack(spacing: UIScreen.main.bounds.width * 0.02) {
                                Image(systemName: "phone")
                                    .foregroundColor(.secondary)

                                Link(phone, destination: phoneURL)
                                    .foregroundColor(.blue)
                            }
                        }

                        if let email = foodbank.email,
                           let emailURL = URL(string: "mailto:\(email)") {

                            HStack(spacing: UIScreen.main.bounds.width * 0.02) {
                                Image(systemName: "envelope")
                                    .foregroundColor(.secondary)

                                Link(email, destination: emailURL)
                                    .foregroundColor(.blue)
                            }
                        }

                    }
                    .font(.subheadline)
                    .padding(.top, -8)

                    // MAP
                    Map(coordinateRegion: $region)
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                        .cornerRadius(12)
                        .shadow(radius: 3)

                    FoodbankNeedsMatchesView(foodbank: foodbank, currSelectedNeeds: currSelectedNeeds)
                }
                .padding()
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}


extension FoodbankNeeds {
    static var preview: FoodbankNeeds {
        let json = """
        {
            "id": "coventry-central",
            "name": "Coventry Central Foodbank",
            "phone": "02476 555 123",
            "email": "info@coventrycentral.foodbank.org.uk",
            "address": "Hope Centre, Sparkbrook St, Coventry",
            "postcode": "CV1 5LB",
            "lat_lng": "52.4068,-1.5070",
            "distance_m": 1825,
            "needs": {
                "needs": "Tinned Tomatoes\\nLong-life Milk\\nRice Pudding\\nCereal\\nTinned Meat\\nInstant Noodles\\nBaked Beans\\nShampoo\\nDeodorant\\nToothpaste"
            },
            "urls": {
                "homepage": "https://coventrycentral.foodbank.org.uk/"
            }
        }
        """.data(using: .utf8)!

        return try! JSONDecoder().decode(FoodbankNeeds.self, from: json)
    }
}

#Preview
{
    FoodbankInfoView(foodbank: .preview)
}

