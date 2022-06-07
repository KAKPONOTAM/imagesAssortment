import Foundation

enum AlertTitles {
    case error
    case OK
    case cancel
    case errorDescription
    case addedToFavorite
    case deleteRequest
    case deleteDescription
    
    var title: String {
        switch self {
        case .error:
            return "Error"
        case .OK:
            return "OK"
        case .cancel:
            return "Cancel"
        case .errorDescription:
            return "Поле не может быть пустым."
        case .addedToFavorite:
            return "Фотография успешно добавлена в избранное."
        case .deleteRequest:
            return "Вы действительно хотите удалить фотографию ?"
        case .deleteDescription:
            return "Данное действие удалит фотографии из вашей коллекции."
        }
    }
}
