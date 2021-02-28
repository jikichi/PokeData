//
//  PokeDataModel.swift
//  PokeData
//
//  Created by jikichi on 2021/02/23.
//

import Foundation
import SwiftyJSON
import RxSwift


class PokemonAPI {
    
    var pokemons: [Pokemon]
    
    init() {
        self.pokemons = []
        self.pokemons = getPokemonListByEnglish()
    }
    
    func getPokemonList() -> [Pokemon] {
        
        let data = try? getJSONData()
        let json = try? JSON(data: data!)
        
        let pokemonList = (json?.map { pokemon -> Pokemon in
            let no: String = pokemon.1["id"].stringValue
            let nameInJapanese: String = pokemon.1["name"]["japanese"].stringValue
            let nameInEnglish: String = pokemon.1["name"]["english"].stringValue
            let nameInChinese: String = pokemon.1["name"]["chinese"].stringValue
            let nameInFrench: String = pokemon.1["name"]["french"].stringValue
            let type: [String] = pokemon.1["type"].arrayObject as! [String]
            let stats: [String : Int] = pokemon.1["base"].dictionaryObject as! [String : Int]
            return Pokemon.init(no: no, nameInJapanese: nameInJapanese, nameInEnglish: nameInEnglish, nameInChinese: nameInChinese, nameInFrench: nameInFrench, type: type, stats: stats)
        })!
        
        return pokemonList
    }
    
    func getPokemonListByEnglish() -> [Pokemon] {
        let data = try? getJSONData()
        let json = try? JSON(data: data!)
        
        let pokemonList = (json?.map { pokemon -> Pokemon in
            let no: String = pokemon.1["id"].stringValue
            let nameInJapanese: String = pokemon.1["name"]["japanese"].stringValue
            let nameInEnglish: String = pokemon.1["name"]["english"].stringValue
            let nameInChinese: String = pokemon.1["name"]["chinese"].stringValue
            let nameInFrench: String = pokemon.1["name"]["french"].stringValue
            let type: [String] = pokemon.1["type"].arrayObject as! [String]
            let stats: [String : Int] = pokemon.1["base"].dictionaryObject as! [String : Int]
            return Pokemon.init(no: no, nameInJapanese: nameInJapanese, nameInEnglish: nameInEnglish, nameInChinese: nameInChinese, nameInFrench: nameInFrench, type: type, stats: stats)
        })!
        
        return pokemonList
    }
    
    
    private func getJSONData() throws -> Data {
        guard let path = Bundle.main.path(forResource: "pokedex", ofType: "json") else {
            throw NSError(domain: "PokemonJson", code: -1, userInfo: [NSLocalizedDescriptionKey: "parseJSON is not Initialized"])
        }
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
    
    func getSearchResults(_ query: String) -> Observable<[Pokemon]> {
        let resultsInJapanese: [Pokemon] = pokemons.filter { $0.nameInJapanese.contains(query.hiraganaToKatakana())
        }
//        let resultsInEnglish: [Pokemon] = pokemons.filter {
//            $0.nameInEnglish.contains(query.lowercased()) }
//        let resultsInChinese: [Pokemon] =
//            pokemons.filter { $0.nameInChinese.contains(query) }
//        let resultsInFrench: [Pokemon] = pokemons.filter { $0.nameInFrench.contains(query.lowercased()) }
//
//        let results: [Pokemon] = resultsInJapanese + resultsInEnglish + resultsInFrench + resultsInChinese
        

        
        return Observable.just(resultsInJapanese)
    }
    
//    func getSearchResultsByEnglish(_ query: String) -> Observable<[Pokemon]> {
//        let results: [Pokemon] = pokemons.filter { $0.name.lowercased().contains(query) }
//        return Observable.just(results)
//    }
}

struct Pokemon: Hashable {
    let no: String
    let nameInJapanese: String
    let nameInEnglish: String
    let nameInChinese: String
    let nameInFrench: String
    let type: [String]
    let stats: [String : Int]
}

extension String {
    // MARK: Public Methods
    
    // ひらがな→カタカナ
    func hiraganaToKatakana() -> String {
        return self.transform(transform: .hiraganaToKatakana, reverse: false)
    }
    
    // MARK: Private Methods
    
    private func transform(transform: StringTransform, reverse: Bool) -> String {
        if let string = self.applyingTransform(transform, reverse: reverse) {
            return string
        } else {
            return ""
        }
    }
}
