import SwiftUI
import OlafDesignKit

internal struct ProductDetailEmptyScreen: View {
    let sendEvent: (ProductDetailEvent) -> Void
    
    var body: some View {
        VStack(spacing: OLAFTheme.shared.dimensions.value(for: .size04)) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy3)
            
            Text("Product not available")
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
            
            Button {
                sendEvent(.goBack)
            } label: {
                Text("Go Back")
                    .font(OLAFTheme.shared.typography.font(.body1Bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, OLAFTheme.shared.dimensions.value(for: .size06))
                    .padding(.vertical, OLAFTheme.shared.dimensions.value(for: .size03))
                    .background(OLAFTheme.shared.colors.buttons.buttonTextActiveDark)
                    .cornerRadius(OLAFTheme.shared.dimensions.value(for: .size02))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 400)
    }
}
