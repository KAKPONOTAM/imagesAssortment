import Foundation

enum TabAndNavigationBarTitles {
    case favoritesImagesTitle
    case searchedImagesTitle
    
    var tabBarTitle: String {
        switch self {
        case .favoritesImagesTitle:
            return "favorites"
        case .searchedImagesTitle:
            return "photos"
        }
    }
}
