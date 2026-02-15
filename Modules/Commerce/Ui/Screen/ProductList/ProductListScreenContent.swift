import SwiftUI
import OlafDesignKit
import Combine
import OlafStateFlowKit

struct ProductListScreenContent: View {
    let state: ProductListState
    let sendEvent: (ProductListEvent) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderSection(state: state, sendEvent: sendEvent)
            
            if !state.products.isEmpty && !state.products.isLoading {
                ResultsSection(count: state.totalResults)
            }
            
            ScrollView {
                ScreenStateHandler(
                    uiState: state.products,
                    initContent: { ProductListInitScreen() },
                    emptyContent: { ProductListEmptyScreen() },
                    successContent: { products in
                        ProductList(products: products, sendEvent: sendEvent)
                    }
                )
            }
        }
    }
}

// MARK: - Header Section

private struct HeaderSection: View {
    let state: ProductListState
    let sendEvent: (ProductListEvent) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: OLAFTheme.shared.dimensions.value(for: .size03)) {
                BaseTextField(
                    model: BaseTextFieldUIModel(
                        placeholder: "Search products...",
                        cornerRadius: OLAFTheme.shared.dimensions.value(for: .size04),
                        borderWidth: 0
                    ),
                    state: TextFieldState(
                        text: state.searchQuery,
                        isDisabled: false
                    ),
                    onTextChange: { newText in
                        sendEvent(.searchQueryChanged(newText))
                    },
                    onSubmit: {
                        sendEvent(.loadProducts)
                    },
                    leading: {
                        Image(systemName: "magnifyingglass")
                    }
                )
            }
            .padding(OLAFTheme.shared.dimensions.value(for: .size04))
            .background(OLAFTheme.shared.colors.background.screenBackground)
        }
    }
}

// MARK: - Results Section

private struct ResultsSection: View {
    let count: Int
    
    var body: some View {
        HStack {
            Text("\(count) RESULTS")
                .font(OLAFTheme.shared.typography.font(.tagMedium))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
            Spacer()
        }
        .padding(.horizontal, OLAFTheme.shared.dimensions.value(for: .size04))
        .padding(.vertical, OLAFTheme.shared.dimensions.value(for: .size03))
    }
}

// MARK: - Product List

private struct ProductList: View {
    let products: [Product]
    let sendEvent: (ProductListEvent) -> Void
    
    var body: some View {
        LazyVStack(spacing: 0, pinnedViews: []) {
            ForEach(products) { product in
                ProductCard(product: product) {
                    sendEvent(.selectProduct(product.id))
                }
                
                if product.id != products.last?.id {
                    Divider()
                        .padding(.leading, 156)
                }
            }
        }
        .background(Color.white)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProductListScreen()
    }
}
