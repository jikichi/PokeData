//
//  PokemonCollectionReusableView.swift
//  PokeData
//
//  Created by jikichi on 2021/03/01.
//

import UIKit

class PokemonCollectionReusableView: UICollectionReusableView {
    
    
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
}
