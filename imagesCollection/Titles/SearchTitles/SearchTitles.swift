import Foundation

enum SearchTitles {
    case random
    
    var title: String {
        switch self {
        case .random:
            return "random"
        }
    }
}
