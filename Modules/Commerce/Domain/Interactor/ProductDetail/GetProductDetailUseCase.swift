import Foundation

public protocol GetProductDetailUseCase {
    func execute(itemId: String) async throws -> ProductDetail
}
