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
    @IBOutlet weak var mainStackView: UIStackView!
    
    var scoreLabel: UILabel!
    var providerStackView :UIStackView?
    
    override func prepareForReuse() {
        providerStackView?.removeFromSuperview()
        providerStackView = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mainStackView.alignment = .top
        mainStackView.distribution = .fill
        mainStackView.spacing = 5
        
        scoreLabel = UILabel()
        scoreLabel.backgroundColor = .systemGreen
        scoreLabel.textColor = .white
        scoreLabel.layer.cornerRadius = 4
        scoreLabel.clipsToBounds = true
        scoreLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        mainStackView.insertArrangedSubview(scoreLabel, at: 1)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupMovie(_ movie: Movie?) {
        posterImageView.kf.setImage(with: URL(string: movie?.getPosterURL() ?? ""))
        titleLabel.text = movie?.original_title
        descLabel.text = movie?.overview
        descLabel.numberOfLines = 2
        let score = movie?.getVoteAverageToString() ?? ""
        scoreLabel.text = "   \(score)   "
    }
    
    func setupProvidersView(data: [ProviderPlataform]?) {
        let view = ProvidersLogoStackViewBuilder.generateProvidersStackView(withPlatforms: data, inView: self.contentView)
        providerStackView = view
        providerStackView?.removeFromSuperview()
        mainStackView?.addArrangedSubview(view)
    }
    
}
