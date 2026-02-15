import Foundation
import os

public final class GetProductsUseCaseImpl: GetProductsUseCase {
    private let repository: CommerceRepository
    private let logger = Logger(subsystem: "com.yourapp.GetProductsUseCase", category: "GetProductsUseCaseImpl")

    public init(repository: CommerceRepository) {
        self.repository = repository
    }

    public func execute(query: String, limit: Int = 50) async throws -> (products: [Product], total: Int) {
        logger.debug("execute(query:\"\(query)\", limit:\(limit))")
        do {
            let result = try await repository.searchProducts(query: query, limit: limit)
            logger.debug("success products=\(result.products.count) total=\(result.total)")
            return result
        } catch {
            logger.error("error: \(error.localizedDescription)")
            throw error
        }
    }
}
