//
//  MovieSearchResultTableCell.swift
//  eMovie
//
//  Created by Leandro Berli on 06/11/2022.
//

import UIKit
import Kingfisher

class MovieSearchResultTableCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupMovie(_ movie: Movie?) {
        posterImageView.kf.setImage(with: URL(string: movie?.getPosterURL() ?? ""))
        titleLabel.text = movie?.original_title
        descLabel.text = movie?.overview
    }
    
}
