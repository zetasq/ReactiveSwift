//
//  AnyObservable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class AnyObservable<Element, Success, Failure: Error>: Observable {
  
  private let _subscribeHandler: (AnyObserver<Element, Success, Failure>) -> Disposable
  
  public init(subscribeHandler: @escaping (AnyObserver<Element, Success, Failure>) -> Disposable) {
    _subscribeHandler = subscribeHandler
  }
  
  @discardableResult
  public func subscribe<T>(with observer: T) -> Disposable where T : Observer, EventType == T.EventType {
    let sink = Sink(targetObserver: observer, subscriptionHandler: _subscribeHandler)
    sink.run()
    return sink
  }
  
}
