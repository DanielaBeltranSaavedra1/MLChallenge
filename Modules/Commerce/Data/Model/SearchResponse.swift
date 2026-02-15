import Foundation

internal struct SearchResponse: Decodable {
    let results: [SearchItem]
    let paging: Paging?
    let total: Int?

    struct Paging: Decodable {
        let total: Int?
    }
}

internal struct SearchItem: Decodable {
    let id: String
    let title: String
    let price: Double
    let originalPrice: Double?
    let thumbnail: String?
    let thumbnailSecure: String?
    let shipping: Shipping?

    struct Shipping: Decodable {
        let freeShipping: Bool?
        let logisticType: String?
        let tags: [String]?

        private enum CodingKeys: String, CodingKey {
            case freeShipping = "free_shipping"
            case logisticType = "logistic_type"
            case tags
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, price
        case originalPrice = "original_price"
        case thumbnail
        case thumbnailSecure = "secure_thumbnail"
        case shipping
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        if let priceDouble = try? container.decode(Double.self, forKey: .price) {
            price = priceDouble
        } else if let priceInt = try? container.decode(Int.self, forKey: .price) {
            price = Double(priceInt)
        } else {
            price = 0.0
        }

        if let origDouble = try? container.decodeIfPresent(Double.self, forKey: .originalPrice) {
            originalPrice = origDouble
        } else if let origInt = try? container.decodeIfPresent(Int.self, forKey: .originalPrice) {
            originalPrice = Double(origInt)
        } else {
            originalPrice = nil
        }

        thumbnail = try? container.decodeIfPresent(String.self, forKey: .thumbnail)
        thumbnailSecure = try? container.decodeIfPresent(String.self, forKey: .thumbnailSecure)
        shipping = try? container.decodeIfPresent(Shipping.self, forKey: .shipping)
    }
}
