import SwiftUI
import OlafDesignKit

struct ErrorScreen: View {
    let code: String
    let message: String
    
    var body: some View {
        VStack(spacing: OLAFTheme.shared.dimensions.value(for: .size04)) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            
            Text("Error")
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            
            Text(message)
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
    }
}
