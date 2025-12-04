import Foundation

struct Need: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

struct FoodbankNeeds: Decodable, Identifiable {
    let id: String
    let name: String
    let phone: String?
    let email: String?
    let address: String?
    let postcode: String?
    let latLng: String?
    let distance: Double?
    let rawNeeds: String?
    let homepage: String?

    let needsLastUpdated: Date?

    private(set) var needsById: [Int: Need] = [:]
    private(set) var needsList: [Need] = []
    private(set) var matchedNeeds: [Int: [PantryItem]] = [:]
    
    var isFavourite: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, address, postcode
        case latLng = "lat_lng"
        case distance = "distance_m"
        case needs, urls
    }

    enum NeedsKeys: String, CodingKey {
        case needs
        case found
    }

    enum UrlsKeys: String, CodingKey {
        case homepage
    }

    private static let needsFoundDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return df
    }()

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

        var foundDate: Date? = nil

        if let needsContainer = try? container.nestedContainer(keyedBy: NeedsKeys.self, forKey: .needs) {
            rawNeeds = try? needsContainer.decode(String.self, forKey: .needs)

            if let foundString = try? needsContainer.decode(String.self, forKey: .found) {
                foundDate = FoodbankNeeds.needsFoundDateFormatter.date(from: foundString)
            }
        } else {
            rawNeeds = nil
        }

        if let urlsContainer = try? container.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls) {
            homepage = try? urlsContainer.decode(String.self, forKey: .homepage)
        } else {
            homepage = nil
        }

        needsLastUpdated = foundDate
        isFavourite = false

        // Build needsList + needsById
        buildNeeds()
    }

    private mutating func buildNeeds() {
        guard let raw = rawNeeds else {
            needsList = []
            needsById = [:]
            return
        }

        let names = raw
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let needs = names.enumerated().map { index, name in
            Need(id: index, name: name)
        }

        self.needsList = needs

        var dict: [Int: Need] = [:]
        for need in needs {
            dict[need.id] = need
        }
        self.needsById = dict
    }

    mutating func registerMatch(needId: Int, item: PantryItem) {
        print("[FoodbankNeeds] trying to match on needId \(needId) with item \(item.name)")
        guard needsById[needId] != nil else { return }
        matchedNeeds[needId, default: []].append(item)
    }
    
    /// Returns a string object that is representative of the distance of the foodbank for the UI.
    public func formattedDistance() -> String {
        guard let d = distance else { return "–" }
        return d >= 1000 ? String(format: "%.1f km away", d / 1000.0)
                         : String(format: "%.0f m away", d)
    }
    
    mutating func toggleFavourite() {
        isFavourite.toggle()
    }
}
