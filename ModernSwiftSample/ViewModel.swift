//
//  ViewModel.swift
//  ModernSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/08/14.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

import Foundation
import RxSwift

struct ViewModel {
    
    let disposeBag = DisposeBag()
    var provider:APIProvider!
    let repositoriesService:RepositoriesService!
    
    
    var repositories: Variable<[Repository]> = Variable([])
    var error: Variable<NSError?> = Variable(nil)
    
    init(provider:APIProvider) {
        self.provider = provider
        repositoriesService = RepositoriesService(provider: provider)
        
        repositoriesService.repositories
            .debug()
            .bindTo(self.repositories)
            .addDisposableTo(disposeBag)
    }
    
    func reloadData() {
        repositoriesService.loadRepositories()
    }

}