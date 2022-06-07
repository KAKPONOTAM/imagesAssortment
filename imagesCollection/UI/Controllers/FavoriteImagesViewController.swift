import UIKit
import Kingfisher

class FavoriteImagesViewController: UIViewController {
    private var favoriteSavedImages: [Results] = [] {
        didSet {
            favoriteImagesTableView.reloadData()
        }
    }
    
    private lazy var favoriteImagesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteImagesTableTableViewCell.self, forCellReuseIdentifier: FavoriteImagesTableTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteSavedImages = ImagesManager.shared.receiveImages()
    }
    
    private func addSubview() {
        view.addSubview(favoriteImagesTableView)
    }
    
    private func cacheAndReturnImage(by index: Int, completion: @escaping (UIImage) -> ()) {
        let imageURLString = favoriteSavedImages[index].urls.raw
        guard let imageURL = URL(string: imageURLString) else { return }
        KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil, downloadTaskUpdated: nil) { result in
            switch result {
            case .success(let image):
                completion(image.image)
            default:
                break
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            favoriteImagesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            favoriteImagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteImagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteImagesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoriteImagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteSavedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteImagesTableTableViewCell.identifier, for: indexPath) as? FavoriteImagesTableTableViewCell else { return UITableViewCell() }
        cacheAndReturnImage(by: indexPath.row) { image in
            cell.configure(with: self.favoriteSavedImages[indexPath.item], with: image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsViewController = DetailsViewController(photoDetails: favoriteSavedImages[indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForFavoriteImagesCell
    }
}
