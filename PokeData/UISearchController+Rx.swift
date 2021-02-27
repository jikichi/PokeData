//
//  UISearchController+Rx.swift
//  PokeData
//
//  Created by jikichi on 2021/02/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {

    var incrementalText: ControlProperty<String?> {
        let delegates: Observable<Void> = Observable.deferred { [weak searchBar = self.base as UISearchBar] () -> Observable<Void> in
            guard let searchBar = searchBar,
               let owner = searchBar.delegate as? UIViewController else { return .empty() }

            let shouldChange = owner.rx
                .methodInvoked(#selector(UISearchBarDelegate.searchBar(_:shouldChangeTextIn:replacementText:)))
                .map { _ in ()}

            return Observable
                .of(shouldChange, searchBar.rx.text.map { _ in () }.asObservable())
                .merge()
        }

        let source = delegates
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap { [weak self = self.base as UISearchBar] _ -> Observable<String?> in .just(self?.text) }
            .distinctUntilChanged { $0 == $1 }

        let bindingObserver = Binder(self.base) { (searchBar, text: String?) in
            searchBar.text = text
        }

        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
