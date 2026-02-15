import SwiftUI
import OlafStateFlowKit

// MARK: - ROUTES

enum CommerceRoutes {
    static let list = "commerce_list"
    static let detail = "commerce_detail"
}

// MARK: - GRAPH

struct CommerceGraph: Graph {
    let graphId: String = "commerce_graph"

    let routes: [String] = [
        CommerceRoutes.list,
        CommerceRoutes.detail
    ]

    let startRoute: String? = CommerceRoutes.list

    func buildView(routeId: String, coordinator: NavigationCoordinator) -> AnyView {
        let baseRoute = extractBaseRoute(from: routeId)
        
        switch baseRoute {
        case CommerceRoutes.list:
            return AnyView(
                ProductListScreen()
                    .environment(\.coordinator, coordinator)
                    .environment(\.routeInfo, RouteInfo(graphName: graphId, screenName: "ProductList"))
            )

        case CommerceRoutes.detail:
            let itemId = extractItemId(from: routeId)
            return AnyView(
                ProductDetailScreen(itemId: itemId)
                    .environment(\.coordinator, coordinator)
                    .environment(\.routeInfo, RouteInfo(graphName: graphId, screenName: "ProductDetail"))
            )

        default:
            return AnyView(EmptyView())
        }
    }

    private func extractBaseRoute(from route: String) -> String {
        if let questionMarkIndex = route.firstIndex(of: "?") {
            return String(route[..<questionMarkIndex])
        }
        return route
    }

    private func extractItemId(from route: String) -> String {
        if let components = URLComponents(string: route),
           let queryItems = components.queryItems,
           let itemIdQuery = queryItems.first(where: { $0.name == "itemId" }),
           let value = itemIdQuery.value {
            return value
        }
        
        if let queryString = route.split(separator: "?").last {
            let params = queryString.split(separator: "&")
            for param in params {
                let keyValue = param.split(separator: "=")
                if keyValue.count == 2, keyValue[0] == "itemId" {
                    return String(keyValue[1])
                }
            }
        }
        
        return ""
    }
}

// MARK: - NAVIGATOR

struct CommerceNavigator: Navigator {
    let graph: Graph = CommerceGraph()
    let isStartDestination: Bool = true
}

// MARK: - MODULE

struct CommerceModule: Module {
    func load() {
        DependencyContainer.shared.registerNavigator(CommerceNavigator())
    }
}
