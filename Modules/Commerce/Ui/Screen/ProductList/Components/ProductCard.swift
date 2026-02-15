import SwiftUI
import OlafDesignKit

internal struct ProductCard: View {
    let product: Product
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: OLAFTheme.shared.dimensions.value(for: .size04)) {
                ProductImage(imageName: product.image)
                ProductInfo(product: product)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(OLAFTheme.shared.dimensions.value(for: .size04))
        }
        .buttonStyle(ProductCardButtonStyle())
    }
}

// MARK: - Product Image

private struct ProductImage: View {
    let imageName: String
    
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .frame(width: 140, height: 140)
            .cornerRadius(OLAFTheme.shared.dimensions.value(for: .size02))
            .overlay(
                Image(systemName: getSystemImageName(for: imageName))
                    .font(.system(size: 48))
                    .foregroundColor(.white)
            )
    }
    
    private func getSystemImageName(for imageName: String) -> String {
        switch imageName {
        case "headphones": return "headphones"
        case "watch": return "applewatch"
        case "shoes": return "figure.run"
        case "camera": return "camera.fill"
        case "sunglasses": return "eyeglasses"
        default: return "photo"
        }
    }
}

// MARK: - Product Info

private struct ProductInfo: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: OLAFTheme.shared.dimensions.value(for: .size02)) {
            Text(product.title)
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            PriceSection(product: product)
            ShippingSection(product: product)
        }
    }
}

// MARK: - Price Section

private struct PriceSection: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: OLAFTheme.shared.dimensions.value(for: .size02)) {
            Text(product.formattedPrice)
                .font(OLAFTheme.shared.typography.font(.h3Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            
            if product.hasDiscount, let percentage = product.discountPercentage {
                Text("\(percentage)% OFF")
                    .font(OLAFTheme.shared.typography.font(.body3Bold))
                    .foregroundColor(OLAFTheme.shared.colors.text.textHierarchyLink)
            }
        }
    }
}

// MARK: - Shipping Section

private struct ShippingSection: View {
    let product: Product
    
    var body: some View {
        Text(product.shippingType.rawValue)
            .font(OLAFTheme.shared.typography.font(.body3Bold))
            .foregroundColor(
                product.hasFreeShipping
                ? OLAFTheme.shared.colors.text.textHierarchy4
                : OLAFTheme.shared.colors.text.textHierarchy3
            )
    }
}

// MARK: - Product Card Button Style

private struct ProductCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                    ? OLAFTheme.shared.colors.background.screenBackground2
                    : Color.white
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
