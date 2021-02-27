//
//  ViewController.swift
//  PokeData
//
//  Created by jikichi on 2021/02/23.
//

import UIKit
import RxSwift
import RxCocoa

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    static var mainBlue = UIColor.init(hex: "03A9F4")
    static var warning = UIColor.init(hex: "f44336")
    static var medium = UIColor.init(hex: "1CB7FF")
    static var row = UIColor.init(hex: "0173A8")
    
    static func customMainBlue(alpha: CGFloat) -> UIColor {
        return UIColor.init(hex: "03A9F4", alpha: alpha)
    }
}

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
        
        
        _ = searchController.searchBar.rx.incrementalText
            .flatMap { text -> Observable<[Pokemon]> in
                guard let text = text else { return .just(API.getPokemonList())}
                return API.getSearchResults(text)
            }
            .bind(to: collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
//        _ = searchController.searchBar.rx.text.orEmpty
//            .asDriver()
//            .debounce(.milliseconds(500))
//            .distinctUntilChanged()
//            .flatMapLatest { query in
//                API.getSearchResults(query)
//                    .startWith([])
//                    .asDriver(onErrorJustReturn: [])
//            }
//            .asDriver(onErrorJustReturn: [])
//            .map { pokemons -> [PokemonSearchResultsViewModel] in
//                if pokemons.count != 0 {
//                    return pokemons.map(PokemonSearchResultsViewModel.init)
//                } else {
//                    return API.getPokemonListByEnglish().map(PokemonSearchResultsViewModel.init)
//                }
//            }
//            .drive(collectionView.rx.items(cellIdentifier: NSStringFromClass(PokemonSearchResultsCollectionViewCell.self), cellType: PokemonSearchResultsCollectionViewCell.self)) { (_, viewModel, cell) in
//                cell.viewModel = viewModel
//            }
//            .disposed(by: disposeBag)
    }
    
    func configureKeyboardDismissesOnScroll() {
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

final class PokemonDataSource: NSObject, UICollectionViewDataSource, RxCollectionViewDataSourceType {
    
    typealias Element = [Pokemon]
    
    private var items: Element = []
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PokemonSearchResultsCollectionViewCell.self), for: indexPath) as! PokemonSearchResultsCollectionViewCell
        cell.viewModel = PokemonSearchResultsViewModel(searchResult: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, items in
            if dataSource.items == items { return }
            dataSource.items = items
            collectionView.reloadData()
        }
        .on(observedEvent)
    }
}


