import Foundation
import Combine
import OlafStateFlowKit


final class ProductDetailViewModel: MVIDelegate<ProductDetailState, ProductDetailEvent, ProductDetailEffect> {

    private let getProductDetailUseCase: GetProductDetailUseCase

    init(itemId: String, getProductDetailUseCase: GetProductDetailUseCase) {
        self.getProductDetailUseCase = getProductDetailUseCase
        super.init(initialState: ProductDetailState(itemId: itemId), initEvent: .onAppear)
    }

    override func handleEvent(_ event: ProductDetailEvent) {
        switch event {
        case .onAppear, .retry:
            Task { [weak self] in
                await self?.loadDetail()
            }
            
        case .goBack:
            setEffect { _ in .navigateBack }
        }
    }

    private func loadDetail() async {
        let id = state.itemId
        setState { state in
            var newState = state
            newState.detail = .loading
            return newState
        }
        do {
            let detail = try await getProductDetailUseCase.execute(itemId: id)
            setState { state in
                var newState = state
                newState.detail = .success(value: detail)
                return newState
            }
        } catch {
            setState { state in
                var newState = state
                newState.detail = .systemError(code: "network_error", message: error.localizedDescription)
                return newState
            }
            setEffect { _ in .showError(error.localizedDescription) }
        }
    }
}
