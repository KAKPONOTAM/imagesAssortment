import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    var images: ImagesData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBarViewControllers()
    }
    
    init(images: ImagesData) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.images = nil
        super.init(coder: coder)
    }
    
    private func createTabBarViewControllers() {
        guard let images = images else { return }
        
        let startViewController = SearchImagesViewController(images: images)
        let favoritesViewController = FavoriteImagesViewController()

        viewControllers = [
                generateViewControllers(viewController: startViewController, title: TabAndNavigationBarTitles.searchedImagesTitle.tabBarTitle, image: Images.tabBarRandomDepartmentImage.titleImage),
                generateViewControllers(viewController: favoritesViewController, title: TabAndNavigationBarTitles.favoritesImagesTitle.tabBarTitle, image: Images.tabBarFavoriteDepartmentImage.titleImage)
        ]
    }
    
    private func generateViewControllers(viewController: UIViewController ,title: String, image: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        
        return navigationController
    }
}
