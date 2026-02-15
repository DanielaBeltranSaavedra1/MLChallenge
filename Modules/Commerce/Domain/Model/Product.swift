import Foundation

// MARK: - PRODUCT MODEL

public struct Product: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let price: Double
    public let originalPrice: Double?
    public let image: String
    public let hasDiscount: Bool
    public let discountPercentage: Int?
    public let hasFreeShipping: Bool
    public let shippingType: ShippingType
    
    public var formattedPrice: String {
        "$\(String(format: "%.2f", price))"
    }
    
    public var formattedOriginalPrice: String? {
        guard let originalPrice = originalPrice else { return nil }
        return "$\(String(format: "%.2f", originalPrice))"
    }
    
    public init(
        id: String,
        title: String,
        price: Double,
        originalPrice: Double? = nil,
        image: String,
        hasDiscount: Bool = false,
        discountPercentage: Int? = nil,
        hasFreeShipping: Bool = false,
        shippingType: ShippingType = .standard
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.originalPrice = originalPrice
        self.image = image
        self.hasDiscount = hasDiscount
        self.discountPercentage = discountPercentage
        self.hasFreeShipping = hasFreeShipping
        self.shippingType = shippingType
    }
}

public enum ShippingType: String {
    case free = "Envío gratis"
    case full = "FULL"
    case standard = "Envío a todo el país"
}
