//
//  Observable+Filter.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/8.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {
  
  @inlinable
  public func filter(_ predicate: @escaping (Element) -> Bool) -> AnyObservable<Element, Success, Failure> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      return self.subscribe(with: AnyObserver(eventHandler: { event in
        switch event {
        case .next(let element):
          if predicate(element) {
            observer.onNext(element)
          }
        case .finish(let result):
          observer.onFinish(result)
        }
      }))
    })
  }
  
}
