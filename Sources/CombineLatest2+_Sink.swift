//
//  CombineLatest2+Sink.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/15.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension CombineLatestObservable2 {
  
  public final class _Sink<T: Observer>: Disposable where T.EventType == CombineLatestObservable2.EventType {
    
    private let _targetObserver: T
    
    // This sink should be only used as a intermediate between the original Sink and the target observer, so we use weak semantics here to avoid retain cycle
    private let _disposableHolder = WeakDisposablesHolder()
    
    private var _lastValue1: O1.Element?
    private var _lastValue2: O2.Element?
    
    private var _lock = os_unfair_lock()
    
    public init(
      targetObserver: T,
      observable1: O1,
      observable2: O2
      ) {
      
      #if DEBUG
      ObjectCounter.increment()
      #endif
      
      _targetObserver = targetObserver

      let subscriber1 = observable1.subscribeOnNext { element1 in
        os_unfair_lock_lock(&self._lock)
        self._lastValue1 = element1
        os_unfair_lock_unlock(&self._lock)
        
        self.forwardIfNeeded()
      }
      _disposableHolder.hold(subscriber1)

      let subscriber2 = observable2.subscribeOnNext { element2 in
        os_unfair_lock_lock(&self._lock)
        self._lastValue2 = element2
        os_unfair_lock_unlock(&self._lock)
        
        self.forwardIfNeeded()
      }
      _disposableHolder.hold(subscriber2)
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
    
    private func forwardIfNeeded() {
      guard !_disposableHolder.isDisposed else {
        return
      }
      
      os_unfair_lock_lock(&self._lock)
      defer {
        os_unfair_lock_unlock(&self._lock)
      }
      
      guard let lastValue1 = _lastValue1,
        let lastValue2 = _lastValue2 else {
          return
      }
      
      _targetObserver.onNext((lastValue1, lastValue2))
    }
  }
  
}

