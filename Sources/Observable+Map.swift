//
//  Observable+Map.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 5/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {
  
  public func map<E>(_ transform: @escaping (Element) -> E) -> AnyObservable<E, Success, Failure> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      return self.subscribe(with: AnyObserver(eventHandler: { event in
        switch event {
        case .next(let element):
            observer.on(.next(transform(element)))
        case .finish(let result):
            observer.on(.finish(result))
        }
      }))
    })
  }
  
  public func compactMap<E>(_ transform: @escaping (Element) -> E?) -> AnyObservable<E, Success, Failure> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      return self.subscribe(with: AnyObserver(eventHandler: { event in
        switch event {
        case .next(let element):
          if let mappedElement = transform(element) {
            observer.on(.next(mappedElement))
          }
        case .finish(let result):
          observer.on(.finish(result))
        }
      }))
    })
  }
  
  public func flatMap<E>(_ transform: @escaping (Element) -> [E]) -> AnyObservable<E, Success, Failure> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      return self.subscribe(with: AnyObserver(eventHandler: { event in
        switch event {
        case .next(let element):
          let mappedElements = transform(element)
          for mappedElement in mappedElements {
            observer.on(.next(mappedElement))
          }
        case .finish(let result):
          observer.on(.finish(result))
        }
      }))
    })
  }
  
}
