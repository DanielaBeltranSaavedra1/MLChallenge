import Foundation

internal struct ItemDetailResponse: Decodable {
    let id: String
    let title: String
    let price: Double
    let pictures: [ItemPicture]?
    let shipping: SearchItem.Shipping?

    struct ItemPicture: Decodable {
        let url: String?
    }
}
