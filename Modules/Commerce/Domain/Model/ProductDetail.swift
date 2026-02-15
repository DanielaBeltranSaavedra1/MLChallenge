import Foundation

public struct ProductDetail: Equatable {
    public let id: String
    public let title: String
    public let price: Double
    public let image: String
    public let hasFreeShipping: Bool

    public var formattedPrice: String { "$\(String(format: "%.2f", price))" }

    public init(id: String, title: String, price: Double, image: String, hasFreeShipping: Bool) {
        self.id = id
        self.title = title
        self.price = price
        self.image = image
        self.hasFreeShipping = hasFreeShipping
    }
}
