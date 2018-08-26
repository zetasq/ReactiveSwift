//
//  UIControlEvents_Tests.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/26.
//  Copyright © 2018 zetasq. All rights reserved.
//

#if os(iOS)

import XCTest

@testable import ReactiveSwift

class UIControlEvents_Tests: XCTestCase {
  
  func testControlEventsObservable() {
    autoreleasepool {
      let control = UIControl()
      
      let disposable = control.rx.observable(forControlEvent: .touchUpInside)
        .subscribeOnNext { _ in
          print("event fired")
        }

      // UIControl's sendActions(for:) does not working in XCTestCase, so we do it manually
      for i in 0..<10 {
        if i == 5 {
          disposable.dispose()
        }
        
        for target in control.allTargets {
          let actionString = control.actions(forTarget: target, forControlEvent: .touchUpInside)!.first!
          
          _ = (target as AnyObject).perform(Selector(actionString), with: control)
        }
      }
    }
    
    XCTAssert(ObjectCounter.currentCount == 0)
  }
}

#endif
