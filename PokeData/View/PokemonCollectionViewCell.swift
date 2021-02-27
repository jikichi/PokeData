//
//  PokemonCollectionViewCell.swift
//  PokeData
//
//  Created by jikichi on 2021/02/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol ReusableView: class {
    var disposeBag: DisposeBag? { get }
    func prepareForReuse()
}

class PokemonCollectionViewCell: UICollectionViewCell {
    
    var disposeBag: DisposeBag?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = nil
        
    }
    
    var pokemonImage: Observable<UIImage?>! {
        didSet {
            let disposeBag = DisposeBag()
            self.pokemonImage
                .asDriver(onErrorJustReturn: UIImage())
                .drive(pokemonImageView.rx.image)
                .disposed(by: disposeBag)
            self.disposeBag = disposeBag
        }
    }
    var pokemonName: Observable<String>! {
        didSet {
            let disposeBag = DisposeBag()
            self.pokemonName
                .asDriver(onErrorJustReturn: "pokemon name is fetching error")
                .drive(nameLabel.rx.text)
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
}

extension PokemonCollectionViewCell {
    private func setupLayout() {
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

extension PokemonCollectionViewCell: ReusableView {
    
}
