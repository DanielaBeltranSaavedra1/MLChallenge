import Foundation

public final class CommerceRepositoryImpl: CommerceRepository {
    public init() {}

    public func searchProducts(query: String, limit: Int = 50) async throws -> (products: [Product], total: Int) {
        print("[CommerceRepositoryImpl] searchProducts(query:\"\(query)\", limit:\(limit))")

        let path = "/sites/MLA/search"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "nickname", value: query),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "0")
        ]
        print("[CommerceRepositoryImpl] GET \(path) queryItems=\(queryItems)")

        do {

            let response: SearchResponse = try await APIClient.shared.request(path: path, queryItems: queryItems, method: "GET")
            print("[CommerceRepositoryImpl] API response results=\(response.results.count) total=\(response.paging?.total ?? response.total ?? -1)")

            let total = response.paging?.total ?? response.total ?? response.results.count

            let products = response.results.map { item -> Product in
                mapSearchItemToProduct(item)
            }

            print("[CommerceRepositoryImpl] mapped products=\(products.count) total=\(total)")
            return (products, total)
        } catch let error as APIError {
            print("[CommerceRepositoryImpl] APIError: \(error)")
            throw error
        } catch {
            print("[CommerceRepositoryImpl] decoding/unknown error: \(error)")
            throw APIError.decoding(error)
        }
    }

    public func getProductDetail(itemId: String) async throws -> ProductDetail {
        print("[CommerceRepositoryImpl] getProductDetail(itemId:\"\(itemId)\")")
        let path = "/items/\(itemId)"
        do {
        
            let response: ItemDetailResponse = try await APIClient.shared.request(path: path, queryItems: nil, method: "GET")
            let detail = mapItemDetailToDomain(response)
            print("[CommerceRepositoryImpl] mapped detail id=\(detail.id) title=\(detail.title)")
            return detail
        } catch let error as APIError {
            print("[CommerceRepositoryImpl] APIError: \(error)")
            throw error
        } catch {
            print("[CommerceRepositoryImpl] decoding/unknown error: \(error)")
            throw APIError.decoding(error)
        }
    }

    private func mapSearchItemToProduct(_ item: SearchItem) -> Product {
        let id = item.id
        let title = item.title
        let price = item.price
        let original = item.originalPrice
        let image = item.thumbnail ?? item.thumbnailSecure ?? ""
        let hasDiscount = (original ?? 0) > price

        var discountPercentage: Int? = nil
        if let orig = original, orig > 0, orig > price {
            let pct = Int(round(((orig - price) / orig) * 100))
            discountPercentage = pct
        }

        let hasFreeShipping = item.shipping?.freeShipping ?? false

        var shippingType: ShippingType = .standard
        if hasFreeShipping {
            shippingType = .free
        } else if let logistic = item.shipping?.logisticType?.lowercased(), logistic.contains("fulfillment") {
            shippingType = .full
        } else if let tags = item.shipping?.tags {
            if tags.contains(where: { $0.lowercased().contains("fulfillment") || $0.lowercased().contains("full") }) {
                shippingType = .full
            }
        }

        return Product(
            id: id,
            title: title,
            price: price,
            originalPrice: original,
            image: image,
            hasDiscount: hasDiscount,
            discountPercentage: discountPercentage,
            hasFreeShipping: hasFreeShipping,
            shippingType: shippingType
        )
    }

    private func mapItemDetailToDomain(_ dto: ItemDetailResponse) -> ProductDetail {
        let image = dto.pictures?.first?.url ?? ""
        return ProductDetail(
            id: dto.id,
            title: dto.title,
            price: dto.price,
            image: image,
            hasFreeShipping: dto.shipping?.freeShipping ?? false
        )
    }
}

// MARK: - DTOs for MercadoLibre search response

private struct SearchResponse: Decodable {
    let results: [SearchItem]
    let paging: Paging?
    let total: Int?

    struct Paging: Decodable {
        let total: Int?
    }
}

private struct SearchItem: Decodable {
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
            originalPrice = origInt != nil ? Double(origInt) : nil
        } else {
            originalPrice = nil
        }

        thumbnail = try? container.decodeIfPresent(String.self, forKey: .thumbnail)
        thumbnailSecure = try? container.decodeIfPresent(String.self, forKey: .thumbnailSecure)
        shipping = try? container.decodeIfPresent(Shipping.self, forKey: .shipping)
    }
}

// MARK: - DTOs for MercadoLibre item detail
private struct ItemDetailResponse: Decodable {
    let id: String
    let title: String
    let price: Double
    let pictures: [ItemPicture]?
    let shipping: SearchItem.Shipping?

    struct ItemPicture: Decodable {
        let url: String?
    }
}


// Un mock simple que imita la firma de APIClient.request(...)
final class MockAPIClient {
    static let shared = MockAPIClient()
    private init() {}

    // Simula latencia
    private func simulateDelay() async {
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
    }

    public func request<T: Decodable>(path: String, queryItems: [URLQueryItem]?, method: String) async throws -> T {
        await simulateDelay()

        // Ruteo simple por path
        if path.hasPrefix("/sites/MLA/search") {
            // Simulamos resultados de búsqueda por nickname
            let results = mockSearchResults(for: queryItems)
            let response = MockSearchResponse(results: results, paging: .init(total: results.count), total: results.count)
            let data = try JSONEncoder().encode(response)
            return try JSONDecoder().decode(T.self, from: data)
        }

        if path.hasPrefix("/items/") {
            // Simulamos detalle de item
            let itemId = path.replacingOccurrences(of: "/items/", with: "")
            let detail = MockItemDetailResponse(
                id: itemId,
                title: "Mocked \(itemId) Title",
                price: 12345.99,
                pictures: [MockItemPicture(url: "https://via.placeholder.com/600x400")],
                shipping: MockShipping(freeShipping: true, logisticType: "fulfillment", tags: ["fulfillment"])
            )
            let data = try JSONEncoder().encode(detail)
            return try JSONDecoder().decode(T.self, from: data)
        }

        // Si no coincide nada, devolvemos un error
        throw NSError(domain: "MockAPIClient", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock route not found: \(path)"])
    }

    // MARK: - Mock helpers

    private func mockSearchResults(for queryItems: [URLQueryItem]?) -> [MockSearchItem] {
        let nickname = queryItems?.first(where: { $0.name == "nickname" })?.value ?? ""
        // Generamos algunos resultados determinísticos con el nickname para ver navegación
        let baseId = nickname.isEmpty ? "MOCK" : nickname.uppercased()
        return [
            MockSearchItem(
                id: "\(baseId)_001",
                title: "Producto \(baseId) 001",
                price: 1000.0,
                original_price: 1200.0,
                thumbnail: "https://via.placeholder.com/140",
                secure_thumbnail: "https://via.placeholder.com/140",
                shipping: MockShipping(freeShipping: true, logisticType: "fulfillment", tags: ["full"])
            ),
            MockSearchItem(
                id: "\(baseId)_002",
                title: "Producto \(baseId) 002",
                price: 2000.0,
                original_price: nil,
                thumbnail: "https://via.placeholder.com/140",
                secure_thumbnail: "https://via.placeholder.com/140",
                shipping: MockShipping(freeShipping: false, logisticType: "me2", tags: [])
            )
        ]
    }
}

// MARK: - Mock DTOs (codificables para simular JSON real)

private struct MockSearchResponse: Codable {
    let results: [MockSearchItem]
    let paging: MockPaging?
    let total: Int?

    struct MockPaging: Codable {
        let total: Int?
    }
}

private struct MockSearchItem: Codable {
    let id: String
    let title: String
    let price: Double
    let original_price: Double?
    let thumbnail: String?
    let secure_thumbnail: String?
    let shipping: MockShipping?
}

private struct MockShipping: Codable {
    let freeShipping: Bool?
    let logisticType: String?
    let tags: [String]?

    enum CodingKeys: String, CodingKey {
        case freeShipping = "free_shipping"
        case logisticType = "logistic_type"
        case tags
    }
}

private struct MockItemDetailResponse: Codable {
    let id: String
    let title: String
    let price: Double
    let pictures: [MockItemPicture]?
    let shipping: MockShipping?
}

private struct MockItemPicture: Codable {
    let url: String?
}
