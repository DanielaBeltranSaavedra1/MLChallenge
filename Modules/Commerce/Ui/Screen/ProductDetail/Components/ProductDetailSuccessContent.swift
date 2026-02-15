import SwiftUI
import OlafDesignKit

internal struct ProductDetailSuccessContent: View {
    let detail: ProductDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProductImageSection(imageName: detail.image)
            
            VStack(alignment: .leading, spacing: OLAFTheme.shared.dimensions.value(for: .size04)) {
                ProductTitleSection(title: detail.title)
                ProductPriceSection(detail: detail)
                
                if detail.hasFreeShipping {
                    ProductShippingBadge()
                }
                
                Divider()
                    .padding(.vertical, OLAFTheme.shared.dimensions.value(for: .size03))
                
                if let description = detail.description, !description.isEmpty {
                    ProductDescriptionSection(description: description)
                }
                
                if let attributes = detail.attributes, !attributes.isEmpty {
                    ProductAttributesSection(attributes: attributes)
                }
                
                Spacer(minLength: OLAFTheme.shared.dimensions.value(for: .size06))
            }
            .padding(OLAFTheme.shared.dimensions.value(for: .size04))
            .background(Color.white)
        }
    }
}

// MARK: - Product Image Section

private struct ProductImageSection: View {
    let imageName: String?
    
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .frame(height: 300)
            .overlay(
                Image(systemName: getSystemImageName(for: imageName))
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            )
    }
    
    private func getSystemImageName(for imageName: String?) -> String {
        guard let imageName = imageName else { return "photo" }
        
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

// MARK: - Product Title Section

private struct ProductTitleSection: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(OLAFTheme.shared.typography.font(.h3Bold))
            .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Product Price Section

private struct ProductPriceSection: View {
    let detail: ProductDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: OLAFTheme.shared.dimensions.value(for: .size02)) {
            HStack(alignment: .firstTextBaseline, spacing: OLAFTheme.shared.dimensions.value(for: .size02)) {
                Text(detail.formattedPrice)
                    .font(OLAFTheme.shared.typography.font(.h2Bold))
                    .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            }
            
            if let originalPrice = detail.originalPrice {
                Text(originalPrice)
                    .font(OLAFTheme.shared.typography.font(.body2Regular))
                    .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy3)
                    .strikethrough()
            }
        }
    }
}

// MARK: - Product Shipping Badge

private struct ProductShippingBadge: View {
    var body: some View {
        HStack(spacing: OLAFTheme.shared.dimensions.value(for: .size02)) {
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 14))
            Text("Free Shipping")
                .font(OLAFTheme.shared.typography.font(.body3Bold))
        }
        .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy4)
        .padding(.horizontal, OLAFTheme.shared.dimensions.value(for: .size03))
        .padding(.vertical, OLAFTheme.shared.dimensions.value(for: .size02))
        .background(
            OLAFTheme.shared.colors.text.textHierarchy4.opacity(0.1)
        )
        .cornerRadius(OLAFTheme.shared.dimensions.value(for: .size02))
    }
}

// MARK: - Product Description Section

private struct ProductDescriptionSection: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: OLAFTheme.shared.dimensions.value(for: .size02)) {
            Text("Description")
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            
            Text(description)
                .font(OLAFTheme.shared.typography.font(.body2Regular))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Product Attributes Section

private struct ProductAttributesSection: View {
    let attributes: [ProductAttribute]
    
    var body: some View {
        VStack(alignment: .leading, spacing: OLAFTheme.shared.dimensions.value(for: .size03)) {
            Text("Specifications")
                .font(OLAFTheme.shared.typography.font(.body1Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
            
            ForEach(attributes, id: \.name) { attribute in
                ProductAttributeRow(attribute: attribute)
            }
        }
    }
}

// MARK: - Product Attribute Row

private struct ProductAttributeRow: View {
    let attribute: ProductAttribute
    
    var body: some View {
        HStack {
            Text(attribute.name)
                .font(OLAFTheme.shared.typography.font(.body3Regular))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy2)
            
            Spacer()
            
            Text(attribute.value)
                .font(OLAFTheme.shared.typography.font(.body3Bold))
                .foregroundColor(OLAFTheme.shared.colors.text.textHierarchy1)
        }
        .padding(.vertical, OLAFTheme.shared.dimensions.value(for: .size01))
    }
}

// MARK: - Supporting Types

struct ProductAttribute {
    let name: String
    let value: String
}

extension ProductDetail {
    var description: String? {
        return nil
    }
    
    var attributes: [ProductAttribute]? {
        return nil
    }
    
    var originalPrice: String? {
        return nil
    }
}
