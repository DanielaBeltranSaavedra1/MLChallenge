import Foundation
import os

public final class CommerceRepositoryImpl: CommerceRepository {
    
    private let logger = Logger(subsystem: "com.yourapp.CommerceRepository", category: "CommerceRepositoryImpl")

    public init() {}

    public func searchProducts(query: String, limit: Int = 50) async throws -> (products: [Product], total: Int) {
        logger.debug("searchProducts(query:\"\(query)\", limit:\(limit))")

        let path = "/sites/MLA/search"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "nickname", value: query),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "0")
        ]
        logger.debug("GET \(path) queryItems=\(queryItems)")

        do {
            let response: SearchResponse = try await APIClient.shared.request(path: path, queryItems: queryItems, method: "GET")
            logger.debug("API response results=\(response.results.count) total=\(response.paging?.total ?? response.total ?? -1)")

            let total = response.paging?.total ?? response.total ?? response.results.count

            let products = response.results.map { mapSearchItemToProduct($0) }

            logger.debug("mapped products=\(products.count) total=\(total)")
            return (products, total)
        } catch let error as APIError {
            logger.error("APIError: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("decoding/unknown error: \(error.localizedDescription)")
            throw APIError.decoding(error)
        }
    }

    public func getProductDetail(itemId: String) async throws -> ProductDetail {
        logger.debug("getProductDetail(itemId:\"\(itemId)\")")
        let path = "/items/\(itemId)"
        do {
            let response: ItemDetailResponse = try await APIClient.shared.request(path: path, queryItems: nil, method: "GET")
            let detail = mapItemDetailToDomain(response)
            logger.debug("mapped detail id=\(detail.id) title=\(detail.title)")
            return detail
        } catch let error as APIError {
            logger.error("APIError: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("decoding/unknown error: \(error.localizedDescription)")
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
            discountPercentage = Int(round(((orig - price) / orig) * 100))
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
