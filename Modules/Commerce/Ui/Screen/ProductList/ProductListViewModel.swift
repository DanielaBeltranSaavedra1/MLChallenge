import Foundation
import Combine
import OlafStateFlowKit

final class ProductListViewModel: MVIDelegate<ProductListState, ProductListEvent, ProductListEffect> {
    
    private let getProductsUseCase: GetProductsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getProductsUseCase: GetProductsUseCase) {
        self.getProductsUseCase = getProductsUseCase
    
        super.init(
            initialState: ProductListState(searchQuery: ""),
            initEvent: .onAppear
        )
    }
    
    override func handleEvent(_ event: ProductListEvent) {
        switch event {
            
        case .onAppear, .loadProducts, .retryLoad:
            Task { [weak self] in
                await self?.loadProducts()
            }
            
        case .searchQueryChanged(let query):
            setState { state in
                var newState = state
                newState.searchQuery = query
                return newState
            }
            
        case .selectProduct(let productId):
            setEffect { _ in .navigateToDetail(productId) }
        }
    }
    
    // MARK: - Combine request
    
    private func loadProducts() async {
        let query = state.searchQuery
        
        // If query is blank, show initial prompt instead of error or loading
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            setState { state in
                var newState = state
                newState.products = .initial
                newState.totalResults = 0
                return newState
            }
            return
        }
        
        setState { state in
            var newState = state
            newState.products = .loading
            return newState
        }
        
        // Execute synchronously; adjust if your use case is async or returns a publisher
        do {
            let response = try await getProductsUseCase.execute(query: query, limit: 30)

            setState { state in
                var newState = state

                if response.products.isEmpty {
                    newState.products = .empty
                    newState.totalResults = 0
                } else {
                    newState.products = .success(value: response.products)
                    newState.totalResults = response.total
                }

                return newState
            }
        } catch {
            setState { state in
                var newState = state
                newState.products = .systemError(
                    code: "network_error",
                    message: error.localizedDescription
                )
                return newState
            }
        }
    }
}

