import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    private var photoDetails: Results?
    private let networkManager = NetworkManager<Results>()
    
    private let detailedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var downloadsAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var addToFavoriteButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFavoriteBarButtonTapped))
    }()
    
    private lazy var deleteImageBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteImageBarButtonTapped))
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(photoDetails: Results) {
        self.photoDetails = photoDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadImageData()
        addSubview()
        setupConstraints()
        setupDetails()
        setupNavigationBar()
    }
    
    private func addSubview() {
        view.addSubview(detailedImageView)
        view.addSubview(authorNameLabel)
        view.addSubview(locationLabel)
        view.addSubview(createdDateLabel)
        view.addSubview(downloadsAmountLabel)
    }
    
    private func setupDetails() {
        if photoDetails == nil {
            detailedImageView.image = Images.emptyCollectionImage.titleImage
        } else {
            guard let imageUrl = URL(string: photoDetails?.urls.raw ?? "")  else { return }
            detailedImageView.kf.setImage(with: imageUrl)
        }
    }
    
    private func setupConstraints() {
        let sidesOffset: CGFloat = 5
        let topAnchorOffset: CGFloat = 10
        let heightConstant: CGFloat = 50
        
        NSLayoutConstraint.activate([
            detailedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailedImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 2)
        ])
        
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: detailedImageView.bottomAnchor, constant: topAnchorOffset),
            authorNameLabel.leadingAnchor.constraint(equalTo: detailedImageView.leadingAnchor),
            authorNameLabel.trailingAnchor.constraint(equalTo: detailedImageView.trailingAnchor),
            authorNameLabel.heightAnchor.constraint(equalToConstant: heightConstant)
        ])
        
        NSLayoutConstraint.activate([
            createdDateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: sidesOffset),
            createdDateLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            createdDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createdDateLabel.heightAnchor.constraint(equalTo: authorNameLabel.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: createdDateLabel.bottomAnchor, constant: sidesOffset),
            locationLabel.leadingAnchor.constraint(equalTo: createdDateLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalTo: createdDateLabel.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            downloadsAmountLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: sidesOffset),
            downloadsAmountLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            downloadsAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            downloadsAmountLabel.heightAnchor.constraint(equalTo: locationLabel.heightAnchor)
        ])
        
        print("daddaadda")
    }
    
    private func setupNavigationBar() {
        guard let photoDetails = self.photoDetails else { return }
        let equalObject = ImagesManager.shared.receiveImages().filter { $0.user.name == photoDetails.user.name }.first
        
        if photoDetails.user.name == equalObject?.user.name {
            navigationItem.rightBarButtonItem = deleteImageBarButton
        } else {
            navigationItem.rightBarButtonItem = addToFavoriteButton
        }
    }
    
    
    @objc private func addToFavoriteBarButtonTapped() {
        let requestAlert = UIAlertController(title: AlertTitles.addedToFavorite.title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertTitles.OK.title, style: .default) { _ in
            guard let photoDetails = self.photoDetails else { return }
            ImagesManager.shared.saveImage(image: photoDetails)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        requestAlert.addAction(okAction)
        present(requestAlert, animated: true)
    }
    
    @objc private func deleteImageBarButtonTapped() {
        let deleteAlert = UIAlertController(title: AlertTitles.deleteRequest.title, message: AlertTitles.deleteDescription.title, preferredStyle: .alert)

        let okAction = UIAlertAction(title: AlertTitles.OK.title, style: .default) { _ in
            guard let photoDetails = self.photoDetails else { return }
            
            ImagesManager.shared.deleteImages(onDeleteImage: photoDetails)
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: AlertTitles.cancel.title, style: .cancel, handler: nil)
        
        deleteAlert.addAction(okAction)
        deleteAlert.addAction(cancelAction)
        present(deleteAlert, animated: true)
    }
    
    private func loadImageData() {
        guard let id = photoDetails?.id else { return }
        networkManager.getRandomImages(url: .singleImageURL(id: id)) { [weak self] results in
                self?.photoDetails = results
                let correctTime = Date.changeStringDateFormat(dateFormat: self?.photoDetails?.createdAt ?? "27.05.2000")
                
                self?.authorNameLabel.text = " Author name: \(self?.photoDetails?.user.name ?? "Danil Sabitov")"
                self?.locationLabel.text =  " Location: \(self?.photoDetails?.user.location ?? "Kazan")"
                self?.createdDateLabel.text = " Created at: \(correctTime)"
                self?.downloadsAmountLabel.text = " Downloads amount: \(self?.photoDetails?.downloads ?? 0)"
            }
        }
    }

