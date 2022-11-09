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
    var providersStackview: UIStackView!
    var providersBgView: UIView!
    
    override func prepareForReuse() {
        providersStackview.subviews.forEach({ $0.removeFromSuperview() })
        providersBgView.isHidden = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImageView.backgroundColor = .systemGray6
        posterImageView.layer.cornerRadius = 7.36
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        
        providersStackview = UIStackView()
        providersStackview.axis = .horizontal
        self.contentView.addSubview(providersStackview)
        providersStackview.translatesAutoresizingMaskIntoConstraints = false
        providersStackview.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        //providersStackview.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        providersStackview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        providersStackview.alignment = .fill
        providersStackview.distribution = .equalSpacing
        providersStackview.spacing = 3
        
        providersBgView = UIView()
        providersBgView.backgroundColor = .systemBackground
        providersBgView.layer.cornerRadius = 8
        providersBgView.alpha = 0.75
        self.contentView.addSubview(providersBgView)
        providersBgView.translatesAutoresizingMaskIntoConstraints = false
        providersBgView.topAnchor.constraint(equalTo: providersStackview.topAnchor, constant: -5).isActive = true
        providersBgView.leadingAnchor.constraint(equalTo: providersStackview.leadingAnchor, constant: -5).isActive = true
        providersBgView.bottomAnchor.constraint(equalTo: providersStackview.bottomAnchor, constant: 5).isActive = true
        providersBgView.trailingAnchor.constraint(equalTo: providersStackview.trailingAnchor, constant: 5).isActive = true
        self.contentView.bringSubviewToFront(providersStackview)
        
        providersBgView.isHidden = true
        providersStackview.isHidden = true
    }
    
    
    func setupMovie(_ movie: Movie?) {
        guard let m = movie else {
            return
        }
        titleLabel.isHidden = true
        posterImageView.kf.setImage(with: URL(string: m.getPosterURL()))
    }
    
    func setupProviders(providers: [ProviderPlataform]?) {
        providersStackview.subviews.forEach({ $0.removeFromSuperview() })
        let suffixArray = Array(providers?.suffix(3) ?? [])
        for p in suffixArray {
            let imageView = UIImageView()
            imageView.image = p.getImage()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            imageView.tintColor = .white
            providersStackview.addArrangedSubview(imageView)
            providersStackview.setNeedsLayout()
        }
        
        if providers?.count ?? 0 > 3 {
            let count = (providers?.count ?? 0) - 3
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .white
            label.numberOfLines = 2
            label.text = "+\(count)"
            
            providersStackview.addArrangedSubview(label)
            label.sizeToFit()
        }
        
        if !(providers?.isEmpty ?? true) {
            providersBgView.isHidden = false
            providersStackview.isHidden = false
        }
    }

}

