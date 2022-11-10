//
//  RecommendedMovieCollectionViewCell.swift
//  eMovie
//
//  Created by Leandro Berli on 09/11/2022.
//

import UIKit

class RecommendedMovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    var providersStackview: UIStackView!
    var providersBgView: UIView!
    
    override func prepareForReuse() {
        providersStackview?.removeFromSuperview()
        providersStackview = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //posterImageView.backgroundColor = .systemGray6
        //posterImageView.layer.cornerRadius = 7.36
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        self.contentView.layer.cornerRadius = 7.36
        self.contentView.clipsToBounds = true
    }
    
    func setupMovie(_ movie: Movie?) {
        guard let m = movie else {
            return
        }
        posterImageView.kf.setImage(with: URL(string: m.getPosterURL()))
        
        if let score = movie?.vote_average {
            scoreLabel.text = "  \(score) scored  "
        } else {
            scoreLabel.superview?.isHidden = true
        }
        
        let providers = [ProviderPlataform(name: "netflix"), ProviderPlataform(name: "amazon prime video"), ProviderPlataform(name: "disney plus")]
        providersStackview = ProvidersLogoStackViewBuilder.generateProvidersStackView(withPlatforms: providers, inView: bottomStackView)
        providersStackview?.removeFromSuperview()
        self.bottomStackView.addArrangedSubview(providersStackview)
    }
    
    func setupProvidersView(data: [ProviderPlataform]?) {
       
    }

}
