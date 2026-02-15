//
//  GetProductsUseCaseImpl.swift
//  MLChallenge
//
//  Created by Daniela Paola Beltran Saavedra on 14/02/26.
//
import Foundation

public final class GetProductsUseCaseImpl: GetProductsUseCase {
    private let repository: CommerceRepository

    public init(repository: CommerceRepository) {
        self.repository = repository
    }

    public func execute(query: String, limit: Int = 50) async throws -> (products: [Product], total: Int) {
        print("[GetProductsUseCaseImpl] execute(query:\"\(query)\", limit:\(limit))")
        do {
            let result = try await repository.searchProducts(query: query, limit: limit)
            print("[GetProductsUseCaseImpl] success products=\(result.products.count) total=\(result.total)")
            return result
        } catch {
            print("[GetProductsUseCaseImpl] error: \(error)")
            throw error
        }
    }
}
