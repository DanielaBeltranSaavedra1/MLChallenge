import SwiftUI
import OlafDesignKit

internal struct ProductDetailInitScreen: View {
    var body: some View {
        VStack(spacing: OLAFTheme.shared.dimensions.value(for: .size04)) {
            ProgressView()
                .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 400)
    }
}

