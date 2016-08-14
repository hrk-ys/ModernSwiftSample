//
//  ViewController.swift
//  ModernSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/08/13.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

import UIKit
import Moya_ObjectMapper
import Moya
import RxCocoa
import RxSwift
import RxDataSources

class ViewController: UITableViewController {

    let disposeBag = DisposeBag()
    
    var provider:APIProvider!
    var repositories:[Repository] = []
    
    var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Repository>>()
    var viewModel:ViewModel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel = ViewModel(provider: provider)
        
        tableView.dataSource = nil
        
        refreshControl = UIRefreshControl()
 
        setupBinding()
        setupDataSource()
        
        viewModel.reloadData()
    }
    
    private func setupBinding() {
        
        viewModel.repositories
            .asObservable()
            .map{ [ SectionModel(model: "Repositories", items: $0) ] }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected
            .map { self.dataSource.itemAtIndexPath($0) }
            .subscribeNext { print("selected repository \($0)") }
            .addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected
            .subscribeNext { self.tableView.deselectRowAtIndexPath($0, animated: true) }
            .addDisposableTo(disposeBag)
        
        if let refresh = refreshControl {
            refresh.rx_controlEvent(.ValueChanged)
                .debug()
                .subscribeNext { self.viewModel.reloadData() }
                .addDisposableTo(disposeBag)
            
            viewModel.repositories
                .asDriver()
                .debug()
                .driveNext {_ in
                    refresh.endRefreshing()
                }
                .addDisposableTo(disposeBag)
            
        }
    }
    
    private func setupDataSource() {
        
        dataSource.configureCell = { ds, tableView, indexPath, repository in
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel!.text = repository.name
            cell.detailTextLabel!.text = repository.desc
            return cell
        }
        
    }
    
}

