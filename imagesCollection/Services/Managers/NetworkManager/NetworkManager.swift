import Foundation

class NetworkManager<T: Decodable> {
    func getRandomImages(url: URLStrings ,completion: @escaping (T) -> ()) {
        guard let url = URL(string: url.url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if error == nil,
               let data = data {
                do {
                    let imageData = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(imageData)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
}
