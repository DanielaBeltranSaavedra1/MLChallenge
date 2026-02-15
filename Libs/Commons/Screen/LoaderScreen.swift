import SwiftUI
import OlafDesignKit

struct LoaderScreen: View {
    var body: some View {
        VStack(spacing: OLAFTheme.shared.dimensions.value(for: .size03)) {
            ProgressView()
                .padding()
            Text("Loading...")
                .font(OLAFTheme.shared.typography.font(.tagRegular))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
    }
}
