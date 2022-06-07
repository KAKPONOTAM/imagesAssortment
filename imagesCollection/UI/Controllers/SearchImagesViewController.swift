import UIKit
import Kingfisher

class SearchImagesViewController: UIViewController {
    private var images: ImagesData?
    private let networkManager = NetworkManager<ImagesData>()
    
    private lazy var searchedImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "search"
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    init(images: ImagesData) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    private func addSubview() {
        view.addSubview(searchedImagesCollectionView)
        view.addSubview(searchTextField)
    }
    
    private func setupConstraints() {
        let sidesOffset: CGFloat = 10
        let searchImagesCollectionViewTopAnchorOffset: CGFloat = 60
        
        NSLayoutConstraint.activate([
            searchedImagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchImagesCollectionViewTopAnchorOffset),
            searchedImagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidesOffset),
            searchedImagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidesOffset),
            searchedImagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: sidesOffset),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidesOffset),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidesOffset),
            searchTextField.bottomAnchor.constraint(equalTo: searchedImagesCollectionView.topAnchor, constant: -sidesOffset)
        ])
    }
    
    private func loadImages(by searchText: String) {
        self.networkManager.getRandomImages(url: .searchURL(imageType: searchText)) { [weak self] imagesData in
            self?.images = imagesData
            self?.searchedImagesCollectionView.reloadData()
        }
    }
    
    private func cacheAndReturnImage(by index: Int, completion: @escaping (UIImage) -> ()) {
        guard let imageURLString = images?.results[index].urls.raw,
              let imageURL = URL(string: imageURLString) else { return }
        KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil, downloadTaskUpdated: nil) { result in
            switch result {
            case .success(let image):
                completion(image.image)
            default:
                break
            }
        }
    }
}

extension SearchImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cacheAndReturnImage(by: indexPath.item) { image in
            cell.configure(with: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - 5) / 2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let photo = images?.results[indexPath.item] else { return }
        let detailsViewController = DetailsViewController(photoDetails: photo)
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension SearchImagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = searchTextField.text else {
            let errorAlert = UIAlertController(title: AlertTitles.error.title, message: AlertTitles.errorDescription.title, preferredStyle: .alert)
            let OkAction = UIAlertAction(title: AlertTitles.OK.title, style: .default) { _ in
                textField.resignFirstResponder()
            }
            
            errorAlert.addAction(OkAction)
            present(errorAlert, animated: true)
            return false }
        
        loadImages(by: searchText)
        
        textField.resignFirstResponder()
        return true
    }
}

