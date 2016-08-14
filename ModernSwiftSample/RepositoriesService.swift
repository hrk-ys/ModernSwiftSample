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

    
    func loadRepositories() {
        
        // APIから取得
        
        provider.request(.Repositories)
            .debug()
            .mapArray(Repository)
            .debug()
            .subscribeNext { repos in

                let realm = self.realm
                
                try! realm.write {
                    realm.add(repos, update: true)
                }
            }
            .addDisposableTo(disposeBag)

    }
}