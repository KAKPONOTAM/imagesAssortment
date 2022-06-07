import Foundation
struct ImagesData: Equatable, Codable {
    var results: [Results]
}

struct Results: Equatable, Codable {
    let id: String
    let createdAt: String
    let user: User
    let urls: Urls
    let downloads: Int?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case user
        case urls
        case id
        case downloads
    }
}

struct User: Equatable, Codable {
    let name: String
    let location: String?
}

struct Urls: Equatable, Codable {
    let raw: String
}
