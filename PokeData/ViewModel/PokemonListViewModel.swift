//
//  PokemonListViewModel.swift
//  PokeData
//
//  Created by jikichi on 2021/02/23.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit.UIImage

class PokemonListViewModel {
    
    var disposeBag = DisposeBag()
    var pokeDataObservable: Observable<[Pokemon]> {
        return pokeDataRelay.asObservable()
    }
    
    let pokeDataRelay = BehaviorRelay<[Pokemon]>(value: [])
    
    init(pokemons: [Pokemon]) {
        pokeDataRelay.accept(pokemons)
    }
    
    func pokemonSearchResults(results: [Pokemon]) -> Void {
        pokeDataRelay.accept(results)
    }
}

class PokemonSearchResultsViewModel {
    
    let searchResult: Pokemon
    
    var pokemonImage: Driver<UIImage>
    var pokemonName: Driver<String>
    
    init(searchResult: Pokemon) {
        self.searchResult = searchResult
        
        self.pokemonImage = Driver.never()
        self.pokemonName = Driver.never()
        
        
        self.pokemonImage = Observable.just(UIImage(named: searchResult.no)!)
            .asDriver(onErrorJustReturn: UIImage())
        self.pokemonName = Observable.just(searchResult.name)
            .asDriver(onErrorJustReturn: "error during fetching")
    }
    
}
