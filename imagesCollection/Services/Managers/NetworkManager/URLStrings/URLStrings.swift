import Foundation

enum URLStrings {
    case searchURL(imageType: String)
    case singleImageURL(id: String)
    
    var url: String {
        switch self {
        case .searchURL(let imageType):
            return "https://api.unsplash.com/search/photos?page=1&query=\(imageType)&client_id=N6bIuWZnuTvEmS1XaV2fcloMd5Pp0Xn-TMz7rJh8L_0"
        case .singleImageURL(let id):
            return "https://api.unsplash.com/photos/\(id)?client_id=N6bIuWZnuTvEmS1XaV2fcloMd5Pp0Xn-TMz7rJh8L_0"
        }
    }
}
