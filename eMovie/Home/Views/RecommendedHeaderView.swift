//
//  RecommendedHeaderView.swift
//  eMovie
//
//  Created by Leandro Berli on 27/10/2022.
//

import UIKit

class FilterButton: UIButton {
    
    enum FilterOption: String, CaseIterable {
        case lang = "   En Japones   "
        case date = "   Lanzado en 2020   "
    }
    
    var option: FilterOption = .lang
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        self.layer.cornerRadius = 34/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
    }
    
    func turnActive() {
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
    }
    
    func turnDeactive() {
        self.backgroundColor = .black
        self.setTitleColor(.white, for: .normal)
    }
}

class RecommendedHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "rec-header-reuse-identifier"
    
    var presenter: HomePresenterProtocol?
    let label = UILabel()
    let filterButtonsStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        backgroundColor = .systemBackground
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        filterButtonsStackView.axis = .horizontal
        addSubview(filterButtonsStackView)
        
        filterButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        filterButtonsStackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12).isActive = true
        filterButtonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        filterButtonsStackView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        filterButtonsStackView.spacing = 8
        
        var aux = 0
        FilterButton.FilterOption.allCases.forEach({
            let button = FilterButton()
            button.option = $0
            button.setTitle($0.rawValue, for: .normal)
            button.addTarget(self, action: #selector(handleFilterOptionSelected), for: .touchUpInside)
            filterButtonsStackView.addArrangedSubview(button)
        })
        
        resetAllFilterButtonsState()
        if let firstOption = filterButtonsStackView.subviews[0] as? FilterButton {
            firstOption.turnActive()
        }
        
        self.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func resetAllFilterButtonsState() {
        filterButtonsStackView.subviews.forEach({
            if let button = $0 as? FilterButton {
                button.turnDeactive()
            }
        })
    }
    
    func setActiveFilterButton(option: FilterButton.FilterOption ) {
        filterButtonsStackView.subviews.forEach({
            if let button = $0 as? FilterButton, button.option == option {
                button.turnActive()
            }
        })
    }
    
    @objc func handleFilterOptionSelected(sender: FilterButton) {
        resetAllFilterButtonsState()
        setActiveFilterButton(option: sender.option)
        presenter?.handleFilterOption(sender.option)
    }
    
}
