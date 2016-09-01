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
    
//    var provider:APIProvider!
    var provider = API.StubProvider()
    var repositories:[Repository] = []
    
    var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Repository>>()
    var viewModel:ViewModel!
   
    deinit {
        print("ViewConntroller deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel = ViewModel(provider: provider,
                              searchTextObserver: searchDisplayController?.searchBar.rx_text.asDriver()
        )
        
        tableView.dataSource = nil
        tableView.rowHeight = 80
        
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
        
        viewModel.error
            .asDriver()
            .driveNext { [weak self] (error) in
                
                guard let _ = error else { return }
                self?.showError(error!)
                
                if let refresh = self?.refreshControl {
                    refresh.endRefreshing()
                }
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected
            .map { [weak self] indexPath in self?.dataSource.itemAtIndexPath(indexPath) }
            .subscribeNext { print("selected repository \($0)") }
            .addDisposableTo(disposeBag)

        tableView.rx_itemSelected
            .subscribeNext { [weak self] indexPath in self?.tableView.deselectRowAtIndexPath(indexPath, animated: true) }
            .addDisposableTo(disposeBag)
        
        if let refresh = refreshControl {
            refresh.rx_controlEvent(.ValueChanged)
                .subscribeNext { [weak self] in self?.viewModel.reloadData() }
                .addDisposableTo(disposeBag)
            
            viewModel.repositories
                .asDriver()
                .driveNext {_ in
                    refresh.endRefreshing()
                }
                .addDisposableTo(disposeBag)
            
        }
        
        if let searchDisplayController = searchDisplayController,
            let searchResults = viewModel.searchResults{
            
            let tableView = searchDisplayController.searchResultsTableView
            
            tableView.dataSource = nil
            
            searchResults
                .asObservable()
                .map{ [ SectionModel(model: "Repositories", items: $0) ] }
                .bindTo(tableView.rx_itemsWithDataSource(dataSource))
                .addDisposableTo(disposeBag)
            

            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }

    }
    
    private func setupDataSource() {
        
        dataSource.configureCell = { ds, tableView, indexPath, repository in
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            if let repositoryCell = cell as? RepositoryCell {
                repositoryCell.repository = repository
                repositoryCell.button.rx_tap.subscribeNext({ () in
                    print(repository)
                })
                    .addDisposableTo(repositoryCell.disposeBag)
            }
            return cell
        }
        
        
    }
    
}

