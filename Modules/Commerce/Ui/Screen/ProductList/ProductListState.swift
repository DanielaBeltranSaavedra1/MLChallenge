import OlafStateFlowKit

struct ProductListState: BaseUiState {
    var searchQuery: String
    var products: UiState<[Product]>
    var totalResults: Int
    
    init(
        searchQuery: String = "",
        products: UiState<[Product]> = .initial,
        totalResults: Int = 0
    ) {
        self.searchQuery = searchQuery
        self.products = products
        self.totalResults = totalResults
    }
}

// MARK: - PRODUCT LIST EVENTS

enum ProductListEvent: UiEvent {
    case onAppear
    case searchQueryChanged(String)
    case loadProducts
    case selectProduct(String)
    case retryLoad
}

// MARK: - PRODUCT LIST EFFECTS

enum ProductListEffect: UiEffect {
    case navigateToDetail(String)
    case showError(String)
}
