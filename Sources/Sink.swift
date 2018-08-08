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
  
  private let _disposableHolder: SingleDisposableHolder
  
  public init(targetObserver: O, subscriptionHandler: (AnyObserver<O.Element, O.Success, O.Failure>) -> Disposable) {
    #if DEBUG
    ObjectCounter.increment()
    #endif
    
    _targetObserver = targetObserver
    _disposableHolder = SingleDisposableHolder()
    
    let bridgingObserver = AnyObserver(eventHandler: forward)
    let subscriptionDisposable = subscriptionHandler(bridgingObserver)
    
    _disposableHolder.hold(subscriptionDisposable)
  }
  
  deinit {
    #if DEBUG
    ObjectCounter.decrement()
    #endif
  }
  
  public func dispose() {
    _disposableHolder.dispose()
  }
  
  public var isDisposed: Bool {
    return _disposableHolder.isDisposed
  }
  
  private func forward(event: O.EventType) {
    guard !_disposableHolder.isDisposed else {
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
