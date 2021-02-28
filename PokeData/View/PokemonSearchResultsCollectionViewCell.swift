//
//  PokemonSearchResultsCollectionViewCell.swift
//  PokeData
//
//  Created by jikichi on 2021/02/25.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonSearchResultsCollectionViewCell: UICollectionViewCell {
    
    var disposeBag: DisposeBag?

    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    var viewModel: PokemonSearchResultsViewModel? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            viewModel.pokemonName
                .map(Optional.init)
                .drive(self.nameLabel.rx.text)
                .disposed(by: disposeBag)
            
            viewModel.pokemonImage
                .drive(self.pokemonImageView.rx.image)
                .disposed(by: disposeBag)
            
            self.disposeBag = disposeBag
        }
    }
    
    var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    private func setupLayout() {
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        pokemonImageView.backgroundColor = .mainBlue
        contentView.addSubview(pokemonImageView)
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
