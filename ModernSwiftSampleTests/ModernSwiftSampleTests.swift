//
//  ModernSwiftSampleTests.swift
//  ModernSwiftSampleTests
//
//  Created by Hiroki Yoshifuji on 2016/08/19.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

import XCTest

import RxSwift
import RxCocoa
import RxTests

@testable import ModernSwiftSample

class ModernSwiftSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialize() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let searchTextObserver = PublishSubject<String>()
        let viewModel = ViewModel(provider: API.StubProvider(), searchTextObserver: searchTextObserver.asDriver(onErrorJustReturn: ""))       

        XCTAssertNotNil(viewModel)
    }
    
    func testReloadData() {
        
        let bag = DisposeBag()
        let expectation = self.expectationWithDescription("load repositories")
        
        
        let searchTextObserver = PublishSubject<String>()
        let viewModel = ViewModel(provider: API.StubProvider(), searchTextObserver: searchTextObserver.asDriver(onErrorJustReturn: ""))       

        
        viewModel.repositories.asObservable()
            .debug()
            .skip(1)
            .subscribeNext { (repositories) in
                XCTAssertEqual(repositories.count, 3)
                expectation.fulfill()
            }
            .addDisposableTo(bag)
        
        viewModel.reloadData()
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
        
    }
    
    func testSearchResult() {
        
        
        let bag = DisposeBag()
        
        
        let scheduler = TestScheduler(initialClock: 0)
        

//        next(150, ""),  // first argument is virtual time, second argument is element value
//        next(210, "a"),
//        next(220, "ab"),
//        next(230, "abc"),
//        completed(300) // virtual time when completed is sent
//        ])

        let results = scheduler.createObserver([Repository])
        
        let searchTextObserver = PublishSubject<String>()
        let viewModel = ViewModel(provider: API.StubProvider(), searchTextObserver: searchTextObserver.debug().asDriver(onErrorJustReturn: ""))

        viewModel.searchResults!
            .asObservable()
            .debug()
            .subscribeNext { print($0) }
            .addDisposableTo(bag)
       
        scheduler.scheduleAt(100) {
            viewModel.searchResults!.debug().asObservable().subscribe(results).addDisposableTo(bag) }
        scheduler.scheduleAt(200) { searchTextObserver.onNext("a") }
        scheduler.scheduleAt(600) { searchTextObserver.onNext("b") }
        scheduler.scheduleAt(900) { searchTextObserver.onCompleted() }
        
        scheduler.start()

        print("finish")
        XCTAssertEqual(results.events.count, 3)
    }
}
