import SwiftUI
import OlafDesignKit
import OlafStateFlowKit

struct ProductDetailScreen: View {
    @StateObject private var viewModel: ProductDetailViewModel
    @Environment(\.coordinator) private var coordinator

    init(itemId: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(
            itemId: itemId,
            getProductDetailUseCase: GetProductDetailUseCaseImpl(
                repository: CommerceRepositoryImpl()
            )
        ))
    }
    var body: some View {
        ScreenContent(
            viewModel: viewModel,
            handleEffects: handleEffect
        ) { state, sendEvent in
            ProductDetailScreenContent(
                state: state,
                sendEvent: sendEvent
            )
        }
        .navigationTitle("Product Detail")
        .navigationBarTitleDisplayMode(.inline)
        .background(OLAFTheme.shared.colors.background.screenBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Share action
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private func handleEffect(_ effect: ProductDetailEffect) {
        switch effect {
        case .navigateBack:
            coordinator.navigateUp()
        case .showError:
            // TODO: Show alert or toast
            break
        }
    }
}
