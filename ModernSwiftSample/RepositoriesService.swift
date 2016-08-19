//
//  RepositoriesService.swift
//  ModernSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/08/14.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

struct RepositoriesService {
    
    let disposeBag = DisposeBag()
    let realm:Realm
    
    var provider:APIProvider!
    
    init(provider:APIProvider) {
        self.provider = provider
        self.realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
    }
    
    var repositories: Observable<[Repository]> {
        return realm.objects(Repository).asObservableArray()
    }

    
    func loadRepositories(query: String? = nil) -> Observable<[Repository]> {
        
        // APIから取得
        
        return Observable.create { (observer) -> Disposable in
            self.provider.request(.Repositories(query))
                .debug()
                .mapArray(Repository)
                .debug()
                .subscribe(
                    onNext: { repos in
                        let realm = self.realm
                        
                        try! realm.write {
                            realm.add(repos, update: true)
                        }
                        
                        observer.onNext(repos)
                        observer.onCompleted()
                    },
                    onError: observer.onError,
                    onCompleted: observer.onCompleted,
                    onDisposed: nil)
                .addDisposableTo(self.disposeBag)
            
            return NopDisposable.instance
        }
    }
}