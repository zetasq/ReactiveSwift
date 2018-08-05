//
//  Sink.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class Sink<O: Observer>: Disposable {

  private let _targetObserver: O
  
  private let _subscriptionHandler: (AnyObserver<O.Element, O.Success, O.Failure>) -> Disposable
  
  private let _composite = CompositeDisposable()
  
  public init(targetObserver: O, subscriptionHandler: @escaping (AnyObserver<O.Element, O.Success, O.Failure>) -> Disposable) {
    _targetObserver = targetObserver
    _subscriptionHandler = subscriptionHandler
  }
  
  public func dispose() {
    _composite.dispose()
  }
  
  public func run() {
    let observer = AnyObserver(eventHandler: forward)
    _composite.insert(_subscriptionHandler(observer))
  }
  
  private func forward(event: O.EventType) {
    guard !_composite.isDisposed else {
      return
    }
    
    _targetObserver.on(event)
    
    switch event {
    case .next:
      break
    case .finish:
      dispose()
    }
  }
  
}
