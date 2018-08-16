//
//  Sink.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class Sink<T: Observer>: Disposable {

  private let _targetObserver: T
  
  private let _disposableHolder = SingleDisposableHolder()
  
  public init(targetObserver: T, subscriptionHandler: (AnyObserver<T.Element, T.Success, T.Failure>) -> Disposable) {
    #if DEBUG
    ObjectCounter.increment()
    #endif
    
    _targetObserver = targetObserver
    
    let bridgingObserver = AnyObserver(eventHandler: self.forward)
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
  
  private func forward(event: T.EventType) {
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
