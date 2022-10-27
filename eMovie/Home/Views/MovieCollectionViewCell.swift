//
//  MovieCollectionViewCell.swift
//  eMovie
//
//  Created by Leandro Berli on 26/10/2022.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImageView.backgroundColor = .systemGray6
        posterImageView.layer.cornerRadius = 7.36
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
    }
    
    func setupMovie(_ movie: Movie?) {
        guard let m = movie else {
            return
        }
        posterImageView.kf.setImage(with: URL(string: m.getPosterURL()))
        titleLabel.text = m.original_title
    }

}

