import Foundation

public protocol CommerceRepository {
    func searchProducts(query: String, limit: Int) async throws -> (products: [Product], total: Int)
    func getProductDetail(itemId: String) async throws -> ProductDetail
}

