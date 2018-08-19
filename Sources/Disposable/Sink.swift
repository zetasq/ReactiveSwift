//
//  Sink.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class Sink<Element, Success, Failure: Error>: Disposable {
  
  private let _typeErasedTargetObserver: AnyObserver<Element, Success, Failure>
  
  private let _disposableHolder = WeakDisposableHolder()
  
  public init<T: Observer>(targetObserver: T)
    where T.Element == Element, T.Success == Success, T.Failure == Failure {
      #if DEBUG
      ObjectCounter.increment()
      #endif
      
      if let anyObserver = targetObserver as? AnyObserver<Element, Success, Failure> {
        // We should reduce indirecting as much as possible
        _typeErasedTargetObserver = anyObserver
      } else {
        _typeErasedTargetObserver = AnyObserver(targetObserver)
      }
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
  
  internal func setOriginalDisposable(_ originalDisposable: Disposable) {
    _disposableHolder.hold(originalDisposable)
  }
  
  internal func forward(event: Event<Element, Success, Failure>) {
    guard !_disposableHolder.isDisposed else {
      return
    }
    
    _typeErasedTargetObserver.on(event)
    
    switch event {
    case .next:
      break
    case .finish:
      dispose()
    }
  }
  
}
