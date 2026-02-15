internal struct MockSearchResponse: Codable {
    let results: [MockSearchItem]
    let paging: MockPaging?
    let total: Int?

    struct MockPaging: Codable {
        let total: Int?
    }
}

internal struct MockSearchItem: Codable {
    let id: String
    let title: String
    let price: Double
    let original_price: Double?
    let thumbnail: String?
    let secure_thumbnail: String?
    let shipping: MockShipping?
}

internal struct MockShipping: Codable {
    let freeShipping: Bool?
    let logisticType: String?
    let tags: [String]?

    enum CodingKeys: String, CodingKey {
        case freeShipping = "free_shipping"
        case logisticType = "logistic_type"
        case tags
    }
}

internal struct MockItemDetailResponse: Codable {
    let id: String
    let title: String
    let price: Double
    let pictures: [MockItemPicture]?
    let shipping: MockShipping?
}

internal struct MockItemPicture: Codable {
    let url: String?
}
