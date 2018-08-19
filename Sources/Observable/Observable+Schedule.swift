//
//  Observable+Schedule.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {
  
  public func schedule(on queue: DispatchQueue) -> AnyObservable<Element, Success, Failure> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      return self.subscribe(with: AnyObserver(eventHandler: { event in
        queue.async {
          observer.on(event)
        }
      }))
    })
  }
  
}
