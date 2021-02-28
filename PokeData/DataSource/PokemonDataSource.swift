//
//  PokemonDataSource.swift
//  PokeData
//
//  Created by jikichi on 2021/02/28.
//

import Foundation
import RxSwift
import RxCocoa

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
