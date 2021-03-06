//
//  KVO_Tests.swift
//  KVO_Tests
//
//  Created by Zhu Shengqi on 1/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import XCTest

@testable import ReactiveSwift

class KVO_Tests: XCTestCase {
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testObservable() {
    do {
      let observable = AnyObservable<Int, Void, NSError>(subscribeHandler: { observer in
        observer.on(.next(1))
        observer.on(.next(2))
        observer.on(.next(3))
        observer.on(.finish(.success(Void())))
        
        return AnyDisposable(disposeHandler: {
          print("disposed")
        })
      })
      
      observable.subscribeOnNext { value in
        print(value)
      }
    }
    
    XCTAssert(ObjectCounter.currentCount == 0)
  }
  
  func testKVO() {
    do {
      let object = TestObject()
      
      object.rx.observable(forKeyPath: \.count)
        .subscribeOnNext { value in
          print(value)
      }
      
      for _ in 0..<10 {
        object.count += 1
      }
    }
    
    XCTAssert(ObjectCounter.currentCount == 0)
  }
  
  func testCombineLatest() {
    autoreleasepool {
      let object1 = TestObject()
      let object2 = TestObject()
      
      let disposable = Rx.combineLatest(object1.rx.observable(forKeyPath: \.count), object2.rx.observable(forKeyPath: \.count))
        .subscribeOnNext { (value1, value2) in
          print("\(value1), \(value2)")
      }
      
      for _ in 0..<5 {
        object1.count += 1
        object2.count += 1
        
        if object1.count == 3 {
          disposable.dispose()
        }
      }
      
      print("DDD")
    }
    
    XCTAssert(ObjectCounter.currentCount == 0)
  }
  
}
