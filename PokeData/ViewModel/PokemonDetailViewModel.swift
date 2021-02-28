//
//  PokemonDetailViewModel.swift
//  PokeData
//
//  Created by jikichi on 2021/02/28.
//

import Foundation
import RxSwift

class PokemonDetailViewModel {
    
    let pokemonObservable: Observable<Pokemon>
    
    init(pokemonObservable: Observable<Pokemon>) {
        self.pokemonObservable = pokemonObservable
    }
    
}
