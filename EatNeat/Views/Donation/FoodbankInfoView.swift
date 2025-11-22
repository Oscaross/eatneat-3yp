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

    @State private var isFavourite = false

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.38, longitude: -1.56),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // --- Title Row ---
                    HStack(alignment: .center) {

                        // Favourite star
                        Button {
                            isFavourite.toggle()
                        } label: {
                            Image(systemName: isFavourite ? "star.fill" : "star")
                                .foregroundColor(isFavourite ? .yellow : .gray)
                                .font(.system(size: 22))
                                .padding(.trailing, 4)
                        }

                        // Title (FoodbankName Foodbank)
                        Text("\(foodbank.name) Foodbank")
                            .font(.title2)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Spacer()

                        if let distance = foodbank.distance {
                            Text(String(format: "%.1f km away", distance / 1000))
                                .foregroundColor(.secondary)
                        }
                    }

                    // --- Map preview ---
                    Map(coordinateRegion: $region)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .shadow(radius: 3)

                    Divider()

                    // --- Needs section ---
                    if let needs = foodbank.needs {
                        Text("Current Needs:")
                            .font(.headline)

                    } else {
                        Text("No current needs listed.")
                            .foregroundColor(.secondary)
                    }

                    Spacer(minLength: 40)
                }
                .padding()
                .navigationTitle("Foodbank Info")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
