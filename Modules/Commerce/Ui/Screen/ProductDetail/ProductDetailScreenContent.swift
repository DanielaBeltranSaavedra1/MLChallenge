import SwiftUI
import OlafDesignKit
import OlafStateFlowKit

struct ProductDetailScreenContent: View {
    let state: ProductDetailState
    let sendEvent: (ProductDetailEvent) -> Void
    
    var body: some View {
        ScrollView {
            ScreenStateHandler(
                uiState: state.detail,
                initContent: { ProductDetailInitScreen() },
                emptyContent: { ProductDetailEmptyScreen(sendEvent: sendEvent) },
                successContent: { detail in
                    ProductDetailSuccessContent(detail: detail)
                },
                businessErrorContent: { code, message in
                    ProductDetailBusinessErrorScreen(
                        code: code,
                        message: message,
                        sendEvent: sendEvent
                    )
                },
                systemErrorContent: { code, message in
                    ProductDetailErrorScreen(
                        code: code,
                        message: message,
                        sendEvent: sendEvent
                    )
                }
            )
        }
    }
}


// MARK: - Success Content
