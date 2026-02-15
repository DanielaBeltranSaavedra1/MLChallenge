import SwiftUI
import OlafStateFlowKit

@main
struct MLChallengeApp: App {
    @StateObject private var navCoordinator: NavigationCoordinator
    
    init() {
        let coordinator = NavigationCoordinator()
        let commerceNavigator = CommerceNavigator()
        coordinator.configure(navigators: [commerceNavigator])
        _navCoordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some Scene {
        WindowGroup {
            AppNavHost(coordinator: navCoordinator)
        }
    }
}
