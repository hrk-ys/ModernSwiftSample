//
//  ViewModel.swift
//  ModernSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/08/14.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

// ViewModelは画面の状態を管理する
// Viewの参照は保持しない
//
import Foundation
import RxSwift
import RxCocoa

class ViewModel {

    let disposeBag = DisposeBag()
    var provider:APIProvider!
    let repositoriesService:RepositoriesService!
    
    
    var repositories: Variable<[Repository]> = Variable([])
    var error: Variable<NSError?> = Variable(nil)
    
    var searchResults: Driver<[Repository]>?
    
    init(provider:APIProvider,
         searchTextObserver: Driver<String>?) {
        self.provider = provider
        repositoriesService = RepositoriesService(provider: provider)
        
        repositoriesService.repositories
            .bindTo(self.repositories)
            .addDisposableTo(disposeBag)
        
        if let searchTextObserver = searchTextObserver {
            searchResults = searchTextObserver
                .debug()
//                .throttle(0.3)
                .distinctUntilChanged()
                .debug()
                .flatMapLatest { [weak self] query -> Driver<[Repository]> in
                    guard let weakSelf = self else { return Driver.just([]) }
                    
                    if query.isEmpty {
                        return Driver.just([])
                    } else {
                        return weakSelf.repositoriesService.loadRepositories(query)
                            .asDriver(onErrorJustReturn: [])
                    }
                }
        }
    }
    
    func reloadData() {
        repositoriesService.loadRepositories()
            .subscribeError { [weak self] (error) in
                self?.error.value = error as NSError
            }
            .addDisposableTo(disposeBag)
    }
    
}