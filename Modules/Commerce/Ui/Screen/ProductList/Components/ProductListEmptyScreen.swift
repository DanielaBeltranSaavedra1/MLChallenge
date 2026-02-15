import SwiftUI
import OlafDesignKit

internal struct ProductListEmptyScreen: View {
    var body: some View {
        VStack(spacing: OLAFTheme.shared.dimensions.value(for: .size04)) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy3)
            
            Text("No products found")
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
            
            Text("Try adjusting your search")
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy3)
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
    }
}
