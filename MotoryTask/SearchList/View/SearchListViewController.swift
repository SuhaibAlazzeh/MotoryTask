//
//  SearchListViewController.swift
//  MotoryTask
//
//  Created by Suhaib Alazzeh on 24/05/2024.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

class SearchListViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: RoundedView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var myFavouriteView: RoundedView!
    @IBOutlet weak var myFavLabel: UILabel!
    @IBOutlet weak var myFavButton: UIButton!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultCollectionView: UICollectionView!

    //MARK: - Variables
    var model: [ServicesModelElement]? = [ServicesModelElement]()
    let selectColor = UIColor(cgColor: CGColor(red: 29.0/255, green: 155.0/255, blue: 240.0/255, alpha: 1))
    let deSelectColor = UIColor(cgColor: CGColor(red: 37.0/255, green: 51.0/255, blue: 65.0/255, alpha: 1))
    let placeholderColor = UIColor(cgColor: CGColor(red: 170.0/255, green: 184.0/255, blue: 194.0/255, alpha: 1))

    var filtered: [ServicesModelElement] = []
    var searchActive: Bool = false
    var favList: [ServicesModelElement] = []
    var isFav: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        setupSearchBar()
        setupTranslation()
        setupResultCollection()
    }

    //MARK: - Actions
    @IBAction func imageButtonTapped(_ sender: Any) {
        imageView.backgroundColor = selectColor
        myFavouriteView.backgroundColor = deSelectColor
        isFav = false
        resultCollectionView.reloadData()
    }

    @IBAction func myFavButtonTapped(_ sender: Any) {
        imageView.backgroundColor = deSelectColor
        myFavouriteView.backgroundColor = selectColor
        isFav = true
        let favModel = model?.filter({$0.likedByUser == true})
            favList = favModel ?? []
            resultCollectionView.reloadData()
    }

    func setupResultCollection() {
        resultCollectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ResultCollectionViewCell")
        self.resultCollectionView.delegate = self
        self.resultCollectionView.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let itemWidth = (UIScreen.main.bounds.width - 72) / 2
        let itemHeight = (resultCollectionView.bounds.height + 70) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .vertical
        resultCollectionView.setCollectionViewLayout(layout, animated: false)
    }

    func setupSearchBar() {

        searchBar.searchTextField.backgroundColor = .clear
        let searchImageView = UIImageView.init(image: UIImage(named: "searchIcon"))
        searchBar.searchTextField.leftView = searchImageView
        searchBar.searchTextField.leftViewMode = .always
        searchBar.layer.masksToBounds = true
        searchBar.layer.cornerRadius = 10
        searchBar.delegate = self

        attributesPlaceholderText(textField: searchBar.searchTextField,
                                  PlaceholderText: "Search your Image ...")
    }

    func attributesPlaceholderText(textField: UITextField, PlaceholderText: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: PlaceholderText,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }

    func setupTranslation() {
        searchTitleLabel.text = "Search"
        imageTitle.text = "Images"
        myFavLabel.text = "My Favourite"
        resultTitleLabel.text = "Result"
        imageButton.setTitle("", for: .normal)
        myFavButton.setTitle("", for: .normal)
    }

    func getData() {

        let url = "https://api.unsplash.com/photos"
        let params = ["page": "1", "client_id": "dQBIzrKA0jrWqOkh8tAqmjc0XNVaTT7qvJgRooIfie8"]
        AF.request(url, method: .get, parameters: params)
            .responseJSON { response in
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let dataModel = try decoder.decode([ServicesModelElement].self, from: data)
                        print(dataModel.first?.id ?? "no")
                        self.model = dataModel

                        self.resultCollectionView.reloadData()
                        // Handle `photos` array containing the parsed data
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
    }

}

extension SearchListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if isFav {
            return favList.count
        }

        if(searchActive) {
            return filtered.count
        }

        return model?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCell", for: indexPath) as! ResultCollectionViewCell

        if isFav {
            let url = URL(string: favList[indexPath.item].urls?.regular ?? "")

            cell.resultImage.kf.setImage(with: url)
            cell.titleLabel.text = favList[indexPath.item].user?.name
            cell.descriptionLabel.text = favList[indexPath.item].description
        } else {
            if(searchActive) {
                let url = URL(string: filtered[indexPath.item].urls?.regular ?? "")

                cell.resultImage.kf.setImage(with: url)
                cell.titleLabel.text = filtered[indexPath.item].user?.name
                cell.descriptionLabel.text = filtered[indexPath.item].description

            } else {
                let url = URL(string: model?[indexPath.item].urls?.regular ?? "")
                // this downloads the image asynchronously if it's not cached yet
                cell.resultImage.kf.setImage(with: url)
                cell.titleLabel.text = model?[indexPath.item].user?.name
                cell.descriptionLabel.text = model?[indexPath.item].description
            }
        }
            return cell
    }
}

extension SearchListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filtered = model?.filter { model in
            return (model.user?.name?.lowercased().contains(searchText.lowercased()) ?? false)
        } ?? []

        if(filtered.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        resultCollectionView.reloadData()
    }
    // to hide keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
