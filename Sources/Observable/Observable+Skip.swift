//
//  Observable+Skip.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {

  public func skip(_ skipCount: Int) -> AnyObservable<Element, Success, Failure> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      var index = 0
      
      return self.subscribe(with: AnyObserver(eventHandler: { event in
        switch event {
        case .next(let element):
          index += 1
          if index > skipCount {
            observer.onNext(element)
          }
        case .finish(let result):
          observer.onFinish(result)
        }
      }))
    })
  }
  
}
