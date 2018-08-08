//
//  ReactiveSwiftTests.swift
//  ReactiveSwiftTests
//
//  Created by Zhu Shengqi on 1/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import XCTest
@testable import ReactiveSwift

class ReactiveSwiftTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testObservable() {
    let observable = AnyObservable<Int, Void, NSError>(subscribeHandler: { observer in
      observer.on(.next(1))
      observer.on(.next(2))
      observer.on(.next(3))
      observer.on(.finish(.success(Void())))
      
      return AnyDisposable(disposeHandler: {
        print("disposed")
      })
    })
    
    observable.subscribe(with: AnyObserver(eventHandler: { event in
      switch event {
      case .next(let element):
        print(element)
      case .finish:
        break
      }
    }))
  }
  
}
