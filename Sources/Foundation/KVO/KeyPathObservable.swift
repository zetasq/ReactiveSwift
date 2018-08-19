//
//  KeyPathObservable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class KeyPathObservable<RootType: _KeyValueCodingAndObserving, ValueType>: Observable {

  public typealias Element = ValueType
  
  public typealias Success = Never
  
  public typealias Failure = NSError // TODO: Use Never
  
  private var observation: NSKeyValueObservation?
  
  private var _lastValue: ValueType?
  private var _lastValue_lock = os_unfair_lock()
  
  private var _disposableToSinkTable: [ProxyDisposable: Sink<Element, Success, Failure>] = [:]
  private var _tableLock = os_unfair_lock()
  
  internal init(object: RootType, keyPath: KeyPath<RootType, ValueType>) {
    #if DEBUG
    ObjectCounter.increment()
    #endif
    
    self.observation = object.observe(keyPath, options: [.initial, .new]) { [weak self] _, change in
      guard let `self` = self else { return }

      guard let newValue = change.newValue else {
        assert(false, "newValue not found in change object")
        return
      }
      
      do {
        os_unfair_lock_lock(&self._lastValue_lock)
        defer {
          os_unfair_lock_unlock(&self._lastValue_lock)
        }
        
        self._lastValue = newValue
      }
      
      os_unfair_lock_lock(&self._tableLock)
      os_unfair_lock_unlock(&self._tableLock)
      
      for sink in self._disposableToSinkTable.values {
        sink.forward(event: .next(newValue))
      }
    }
  }
  
  deinit {
    #if DEBUG
    ObjectCounter.decrement()
    #endif
  }

  public func subscribe<T>(with observer: T) -> Disposable where T : Observer, KeyPathObservable.Element == T.Element, KeyPathObservable.Failure == T.Failure, KeyPathObservable.Success == T.Success {
    
    os_unfair_lock_lock(&_tableLock)
    defer {
      os_unfair_lock_unlock(&_tableLock)
    }
    
    let disposable = ProxyDisposable()
    disposable.delegate = self
    
    let sink = Sink(targetObserver: observer)
    _disposableToSinkTable[disposable] = sink
    
    sink.setOriginalDisposable(disposable)
    
    do {
      os_unfair_lock_lock(&_lastValue_lock)
      defer {
        os_unfair_lock_unlock(&_lastValue_lock)
      }
      
      if let lastValue = _lastValue {
        sink.forward(event: .next(lastValue))
      }
    }
    
    return sink
  }
  
}

extension KeyPathObservable: ProxyDisposableDelegate {
  
  func proxyDisposableRequestDispose(_ disposable: ProxyDisposable) {
    os_unfair_lock_lock(&_tableLock)
    defer {
      os_unfair_lock_unlock(&_tableLock)
    }
    
    guard let _ = _disposableToSinkTable.removeValue(forKey: disposable) else {
      assert(false, "No disposable exist in table when disposing in KeyPathObservable")
    }
  }
  
}
