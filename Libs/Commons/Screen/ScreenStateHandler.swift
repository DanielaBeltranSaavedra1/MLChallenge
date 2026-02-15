import SwiftUI
import OlafStateFlowKit

struct ScreenStateHandler<T, Content: View, InitContent: View, EmptyContent: View, BusinessErrorContent: View, SystemErrorContent: View>: View {
    let uiState: UiState<T>
    let initContent: () -> InitContent
    let emptyContent: () -> EmptyContent
    let successContent: (T) -> Content
    let businessErrorContent: (String, String) -> BusinessErrorContent
    let systemErrorContent: (String, String) -> SystemErrorContent
    
    init(
        uiState: UiState<T>,
        @ViewBuilder initContent: @escaping () -> InitContent,
        @ViewBuilder emptyContent: @escaping () -> EmptyContent,
        @ViewBuilder successContent: @escaping (T) -> Content,
        @ViewBuilder businessErrorContent: @escaping (String, String) -> BusinessErrorContent = { code, message in
            ErrorScreen(code: code, message: message)
        },
        @ViewBuilder systemErrorContent: @escaping (String, String) -> SystemErrorContent = { code, message in
            ErrorScreen(code: code, message: message)
        }
    ) {
        self.uiState = uiState
        self.initContent = initContent
        self.emptyContent = emptyContent
        self.successContent = successContent
        self.businessErrorContent = businessErrorContent
        self.systemErrorContent = systemErrorContent
    }
    
    var body: some View {
        switch uiState {
        case .initial:
            initContent()
            
        case .loading:
            LoaderScreen()
            
        case .success(let data):
            successContent(data)
            
        case .empty:
            emptyContent()
            
        case .systemError(let code, let message):
            systemErrorContent(code, message)
            
        case .businessError(let code, let message):
            businessErrorContent(code, message)
        }
    }
}
