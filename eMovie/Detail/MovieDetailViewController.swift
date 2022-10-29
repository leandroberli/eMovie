//
//  MoviewDetailViewController.swift
//  eMovie
//
//  Created by Leandro Berli on 28/10/2022.
//

import UIKit
import WebKit

protocol MovieDetailViewProtocol: AnyObject {
    var presenter: MovieDetailPresenterProtocol? { get set }
    
    func updateViewWithMovie(data: MovieDetail?)
    func updateWebiewWith(url: URLRequest)
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
    @IBOutlet weak var webView: WKWebView!
    
    var presenter: MovieDetailPresenterProtocol?
    var topGradient: CAGradientLayer?
    var bottomGradient: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        presenter?.getMovieDetail()
        presenter?.getMovieVideos()
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
        watchTrailerButton.layer.cornerRadius = 8
        watchTrailerButton.addTarget(self, action: #selector(didTapViewTrailer), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.cleanCurrentGradients()
            self.generateGradients()
        }
    }
    
    func generateGradients() {
        let width = self.view.bounds.width
        let height = 150.0
        
        //Top gradient
        let topGradientView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        topGradientView.accessibilityIdentifier = "topGradientView"
        let gradient = CAGradientLayer()
        gradient.name = "topGradient"
        gradient.frame = topGradientView.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.75, 1]
        topGradientView.layer.insertSublayer(gradient, at: 0)
        self.topGradient = gradient
        
        self.view.addSubview(topGradientView)
        self.view.bringSubviewToFront(topGradientView)
        topGradientView.translatesAutoresizingMaskIntoConstraints = false
        topGradientView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        topGradientView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topGradientView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topGradientView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        //Bottom gradient
        let gradient2 = CAGradientLayer()
        gradient2.name = "bottomGradient"
        gradient2.frame = overlayPosterView.bounds
        gradient2.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient2.locations = [0.0, 0.75, 1]
        overlayPosterView.layer.insertSublayer(gradient2, at: 0)
        self.bottomGradient = gradient2
    }
    
    private func cleanCurrentGradients() {
        topGradient?.removeFromSuperlayer()
        bottomGradient?.removeFromSuperlayer()
    }
    
    @objc func didTapViewTrailer(_ sender: UIButton) {
        scrollToTrailer()
    }
    
    private func scrollToTrailer() {
        if let scrollView = self.view.subviews.first(where: { type(of: $0) == UIScrollView.self }) as? UIScrollView {
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func updateViewWithMovie(data: MovieDetail?) {
        posterImageView.kf.setImage(with: URL(string: data?.getPosterURL() ?? ""))
        titleLabel.text = data?.original_title ?? ""
        overviewLabel.text = data?.overview ?? ""
        releaseYearLabel.text = "\(data?.getReleaseYear() ?? 0)"
        originalLangLabel.text = data?.original_language?.uppercased()
        scoreLabel.text = "\(data?.vote_average ?? 0.0)"
        genreLabel.text = data?.getGenresString()
    }
    
    func updateWebiewWith(url: URLRequest) {
        self.webView.load(url)
    }
}
