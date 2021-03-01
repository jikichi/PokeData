//
//  ViewController.swift
//  PokeData
//
//  Created by jikichi on 2021/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let dataSource = PokemonDataSource()
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.tintColor = .row
        sc.searchBar.sizeToFit()
        sc.searchBar.isTranslucent = false
        sc.searchBar.delegate = self
        return sc
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(PokemonSearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(PokemonSearchResultsCollectionViewCell.self))
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindCollectionView()
        configureKeyboardDismissesOnScroll()
        setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = .mainBlue
        collectionView.backgroundColor = .row
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 350)
        layout.minimumLineSpacing = 20
        return layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "ポケモンずかん"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font : UIFont.boldSystemFont(ofSize: 26.0)
        ]
        navigationController?.navigationBar.backgroundColor = .mainBlue
        navigationController?.navigationBar.barTintColor = .mainBlue
        
        
        
        navigationItem.searchController = searchController
        
        navigationItem.searchController?.searchBar.searchTextField.backgroundColor = .row
        navigationItem.searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "ポケモンのなまえでけんさく", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainBlue])
    }
    
}

extension ViewController {
    private func bindCollectionView() {
        
        let API = PokemonAPI()
        
        let pokemonListObservable = searchController.searchBar.rx.incrementalText
            .flatMap { text -> Observable<[Pokemon]> in
                guard let text = text else { return .just([])}
                if text == "" { return .just(API.getPokemonList())}
                return API.getSearchResults(text)
            }
        
        pokemonListObservable
            .bind(to: collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                let pokemonObservable = pokemonListObservable.flatMap { pokemon -> Observable<Pokemon> in
                    return .just(pokemon[indexPath.row])
                }
                let nextViewController = PokemonDetailViewController(viewModel: PokemonDetailViewModel(pokemonObservable: pokemonObservable))
                self?.navigationController?.pushViewController(nextViewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func configureKeyboardDismissesOnScroll() {
        let searchBar = self.searchController.searchBar
        
        collectionView.rx.contentOffset
            .asDriver()
            .drive(onNext: { _ in
                if searchBar.isFirstResponder {
                    _ = searchBar.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
}


