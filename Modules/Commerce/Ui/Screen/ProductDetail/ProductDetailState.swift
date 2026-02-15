import Foundation
import OlafStateFlowKit

struct ProductDetailState: BaseUiState {
    var itemId: String
    var detail: UiState<ProductDetail>

    init(itemId: String) {
        self.itemId = itemId
        self.detail = .initial
    }
}

enum ProductDetailEvent: UiEvent {
    case onAppear
    case retry
    case goBack
}

enum ProductDetailEffect: UiEffect {
    case showError(String)
    case navigateBack
}
