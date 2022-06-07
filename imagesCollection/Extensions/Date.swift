import Foundation

extension Date {
    static func changeStringDateFormat(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        guard let date = dateFormatter.date(from: dateFormat) else { return "" }
        
        dateFormatter.dateFormat = "d MMMM, yyyy"
        
        return dateFormatter.string(from: date)
        
    }
}
