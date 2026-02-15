import Foundation
final class MockAPIClient {
    static let shared = MockAPIClient()
    private init() {}

    private func simulateDelay() async {
        try? await Task.sleep(nanoseconds: 300_000_000)
    }

    public func request<T: Decodable>(path: String, queryItems: [URLQueryItem]?, method: String) async throws -> T {
        await simulateDelay()
        if path.hasPrefix("/sites/MLA/search") {
            // Simulamos resultados de búsqueda por nickname
            let results = mockSearchResults(for: queryItems)
            let response = MockSearchResponse(results: results, paging: .init(total: results.count), total: results.count)
            let data = try JSONEncoder().encode(response)
            return try JSONDecoder().decode(T.self, from: data)
        }

        if path.hasPrefix("/items/") {
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

        throw NSError(domain: "MockAPIClient", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock route not found: \(path)"])
    }

    // MARK: - Mock helpers

    private func mockSearchResults(for queryItems: [URLQueryItem]?) -> [MockSearchItem] {
        let nickname = queryItems?.first(where: { $0.name == "nickname" })?.value ?? ""
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
