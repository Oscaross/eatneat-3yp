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
    @State private var position: MapCameraPosition // where is the map centered?
    
    init(foodbank: FoodbankNeeds, currSelectedNeeds: Set<Int> = []) {
        self.foodbank = foodbank
        self.currSelectedNeeds = currSelectedNeeds
        // decode lat and long from foodbank
        let lat = foodbank.latitude ?? 0
        let lng = foodbank.longitude ?? 0
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)

        // Slightly zoomed out
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
        )

        _position = State(initialValue: .region(region))
    }



    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.03) {

                    // MARK: Title Row
                    HStack(spacing: 20) {

                        // Favourite star
                        Button {
                            isFavourite.toggle()
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } label: {
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

                    // MARK: Interactive map viewer showing dropoff point and user location
                    
                    let center = CLLocationCoordinate2D(
                        latitude: foodbank.latitude ?? 0,
                        longitude: foodbank.longitude ?? 0
                    )

                    Map(position: $position) {

                        // Show system user location (blue dot) - native code that iOS handles
                        UserAnnotation()

                        // Custom foodbank pin
                        Annotation(foodbank.name, coordinate: center) {
                            ZStack {
                                // Pin “stem”
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppStyle.primary.opacity(0.9))
                                    .frame(width: 4, height: 14)
                                    .offset(y: 10)

                                // Circular head with basket icon to indicate foodbank location
                                ZStack {
                                    Circle()
                                        .fill(AppStyle.primary)
                                        .frame(width: 32, height: 32)
                                        .shadow(radius: 3)

                                    Image(systemName: "basket.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.35)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .mapControls {
                        MapUserLocationButton() // standard floating button to jump to user
                        MapCompass()
                    }

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

