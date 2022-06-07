import Foundation
import UIKit

enum Images {
    case loadImage
    case tabBarRandomDepartmentImage
    case tabBarFavoriteDepartmentImage
    case emptyCollectionImage
    
    var titleImage: UIImage? {
        switch self {
        case .loadImage:
            return UIImage(named: "welcome")
        case .tabBarRandomDepartmentImage:
            return UIImage(systemName: "photo.on.rectangle")
        case .tabBarFavoriteDepartmentImage:
            return UIImage(systemName: "heart.fill")
        case .emptyCollectionImage:
            return UIImage(named: "empty")
        }
    }
}
