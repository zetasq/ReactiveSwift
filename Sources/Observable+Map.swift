//
//  Observable+Map.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 5/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {
  
  public func map<E, S, F: Error>(_ transform: @escaping (EventType) -> Event<E, S, F>) -> AnyObservable<E, S, F> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      return self.subscribe(with: AnyObserver(eventHandler: { event in
        observer.on(transform(event))
      }))
    })
  }
  
}
