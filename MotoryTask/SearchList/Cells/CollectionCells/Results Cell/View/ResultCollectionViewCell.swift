//
//  ResultCollectionViewCell.swift
//  MotoryTask
//
//  Created by Suhaib Alazzeh on 24/05/2024.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!

    var favStatus: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favButton.setTitle("", for: .normal)
    }

    @IBAction func favButtonTapped(_ sender: Any) {
        favStatus = !favStatus
        if favStatus {
            favImage.image = UIImage(named: "favIcon")
        } else {
            favImage.image = UIImage(named: "unFavIcon")
        }
    }
}
