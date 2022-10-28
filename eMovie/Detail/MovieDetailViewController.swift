//
//  MoviewDetailViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 28/10/2022.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    var presenter: MovieDetailPresenterProtocol? { get set }
    
    func updateViewWithMovie(data: MovieDetail?)
}

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overlayPosterView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var originalLangLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var watchTrailerButton: UIButton!
    
    var presenter: MovieDetailPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        generateGradients()
        presenter?.getMovieDetail()
    }
    
    private func configViews() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.accessibilityPath?.lineWidth = 0
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        watchTrailerButton.layer.borderWidth = 1
        watchTrailerButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func updateViewWithMovie(data: MovieDetail?) {
        posterImageView.kf.setImage(with: URL(string: data?.getPosterURL() ?? ""))
        titleLabel.text = data?.original_title ?? ""
        overviewLabel.text = data?.overview ?? ""
        releaseYearLabel.text = "\(data?.getReleaseYear() ?? 0)"
        originalLangLabel.text = data?.original_language?.uppercased()
        scoreLabel.text = "\(data?.vote_average ?? 0.0)"
    }
    
    func generateGradients() {
        let width = self.view.bounds.width
        let height = 150.0
        
        let topGradientView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let gradient = CAGradientLayer()
        gradient.frame = topGradientView.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.75, 1]
        topGradientView.layer.insertSublayer(gradient, at: 0)
        
        self.view.addSubview(topGradientView)
        self.view.bringSubviewToFront(topGradientView)
        topGradientView.translatesAutoresizingMaskIntoConstraints = false
        topGradientView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        topGradientView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topGradientView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topGradientView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        let gradient2 = CAGradientLayer()
        gradient2.name = "bottomGradient"
        print(#function, overlayPosterView.bounds)
        gradient2.frame = overlayPosterView.bounds
        gradient2.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient2.locations = [0.0, 0.75, 1]
        overlayPosterView.layer.insertSublayer(gradient2, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let botGradient = overlayPosterView.layer.sublayers?.first(where: { $0.name == "bottomGradient"}) as? CAGradientLayer {
            botGradient.frame = overlayPosterView.bounds
        }
    }
}
