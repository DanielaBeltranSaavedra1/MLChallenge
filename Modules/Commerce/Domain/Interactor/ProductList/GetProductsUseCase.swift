import Foundation

public protocol GetProductsUseCase {
    func execute(query: String, limit: Int) async throws -> (products: [Product], total: Int)
}

