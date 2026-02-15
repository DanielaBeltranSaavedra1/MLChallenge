import Foundation

public final class GetProductDetailUseCaseImpl: GetProductDetailUseCase {
    private let repository: CommerceRepository

    public init(repository: CommerceRepository) {
        self.repository = repository
    }

    public func execute(itemId: String) async throws -> ProductDetail {
        print("[GetProductDetailUseCaseImpl] execute(itemId:\"\(itemId)\")")
        do {
            let detail = try await repository.getProductDetail(itemId: itemId)
            print("[GetProductDetailUseCaseImpl] success title=\(detail.title)")
            return detail
        } catch {
            print("[GetProductDetailUseCaseImpl] error: \(error)")
            throw error
        }
    }
}
