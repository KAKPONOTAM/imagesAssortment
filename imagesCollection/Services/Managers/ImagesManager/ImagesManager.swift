import Foundation

class ImagesManager {
    static var shared = ImagesManager()
    private init() {}
    
      func saveImage(image: Results) {
        var loadedImages = receiveImages() 
        loadedImages.append(image)
        
        UserDefaults.standard.setValue(encodable: loadedImages, forKey: UserDefaultsKeys.savedImage.rawValue)
    }
    
     func receiveImages() -> [Results] {
        guard let model = UserDefaults.standard.loadValue([Results].self, forKey: UserDefaultsKeys.savedImage.rawValue)  else { return [] }
        return model
    }
    
    func deleteImages(onDeleteImage: Results) {
        var loadedImages = receiveImages()
        
        if let firstIndex = loadedImages.firstIndex(of: onDeleteImage) {
            loadedImages.remove(at: firstIndex)
        }
        
        UserDefaults.standard.setValue(encodable: loadedImages, forKey: UserDefaultsKeys.savedImage.rawValue)
    }
}
