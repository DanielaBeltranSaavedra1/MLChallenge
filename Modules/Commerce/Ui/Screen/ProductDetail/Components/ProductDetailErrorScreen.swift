import SwiftUI
import OlafDesignKit

internal struct ProductDetailErrorScreen: View {
    let code: String
    let message: String
    let sendEvent: (ProductDetailEvent) -> Void
    
    var body: some View {
        VStack(spacing: OLAFTheme.shared.dimensions.value(for: .size04)) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            
            Text("Error loading product")
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            
            Text(message)
                .font(OLAFTheme.shared.typography.font(.body2Regular))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack(spacing: OLAFTheme.shared.dimensions.value(for: .size03)) {
                Button {
                    sendEvent(.retry)
                } label: {
                    Text("Retry")
                        .font(OLAFTheme.shared.typography.font(.body1Bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, OLAFTheme.shared.dimensions.value(for: .size06))
                        .padding(.vertical, OLAFTheme.shared.dimensions.value(for: .size03))
                        .background(OLAFTheme.shared.colors.buttons.buttonTextActiveDark)
                        .cornerRadius(OLAFTheme.shared.dimensions.value(for: .size02))
                }
                
                Button {
                    sendEvent(.goBack)
                } label: {
                    Text("Go Back")
                        .font(OLAFTheme.shared.typography.font(.body1Bold))
                        .foregroundColor(OLAFTheme.shared.colors.buttons.buttonTextActiveDark)
                        .padding(.horizontal, OLAFTheme.shared.dimensions.value(for: .size06))
                        .padding(.vertical, OLAFTheme.shared.dimensions.value(for: .size03))
                        .background(
                            OLAFTheme.shared.colors.buttons.buttonTextActiveDark.opacity(0.1)
                        )
                        .cornerRadius(OLAFTheme.shared.dimensions.value(for: .size02))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 400)
        .padding()
    }
}

// MARK: - Business Error Screen

internal struct ProductDetailBusinessErrorScreen: View {
    let code: String
    let message: String
    let sendEvent: (ProductDetailEvent) -> Void
    
    var body: some View {
        VStack(spacing: OLAFTheme.shared.dimensions.value(for: .size04)) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 48))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)

            Text(message)
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
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
