//
//  PokemonDetailViewController.swift
//  PokeData
//
//  Created by jikichi on 2021/02/28.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    let viewModel: PokemonDetailViewModel!
    
    convenience init() {
        fatalError("init() has not been implemented")
    }
    required init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

}
