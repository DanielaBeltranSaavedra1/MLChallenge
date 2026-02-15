import SwiftUI
import OlafDesignKit
import Combine
import OlafStateFlowKit

struct ProductListScreen: View {
    @StateObject private var viewModel = ProductListViewModel(
        getProductsUseCase: GetProductsUseCaseImpl(
            repository: CommerceRepositoryImpl()
        )
    )
    @Environment(\.coordinator) var coordinator
    
    var body: some View {
        ScreenContent(
            viewModel: viewModel,
            handleEffects: handleEffect
        ) { state, sendEvent in
            ProductListScreenContent(state: state, sendEvent: sendEvent)
        }
        .navigationTitle("Products")
        .navigationBarTitleDisplayMode(.large)
        .background(OLAFTheme.shared.colors.background.screenBackground)
    }
    
    private func handleEffect(_ effect: ProductListEffect) {
        switch effect {
        case .navigateToDetail(let productId):
            let route = "\(CommerceRoutes.detail)?itemId=\(productId)"
            coordinator.navigate(routeId: route)
            
        case .showError:
            // TODO: Show toast or alert
            break
        }
    }
}
