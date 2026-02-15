import Foundation
import os

public final class GetProductDetailUseCaseImpl: GetProductDetailUseCase {
    private let repository: CommerceRepository
    private let logger = Logger(subsystem: "com.yourapp.GetProductDetailUseCase", category: "GetProductDetailUseCaseImpl")

    public init(repository: CommerceRepository) {
        self.repository = repository
    }

    public func execute(itemId: String) async throws -> ProductDetail {
        logger.debug("execute(itemId:\"\(itemId)\")")
        do {
            let detail = try await repository.getProductDetail(itemId: itemId)
            logger.debug("success title=\(detail.title)")
            return detail
        } catch {
            logger.error("error: \(error.localizedDescription)")
            throw error
        }
    }
}
