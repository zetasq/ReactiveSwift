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
  
  private var _bag = Bag<AnyObserver<Element, Success, Failure>>()
  private var _bag_lock = os_unfair_lock()
  
  internal init(object: RootType, keyPath: KeyPath<RootType, ValueType>) {
    #if DEBUG
    ObjectCounter.increment()
    #endif
    
    // KeyPathObservable will be retained by the object, so we can use weak self (this also prevents retain cycle in KeyPathObservable)
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
      
      os_unfair_lock_lock(&self._bag_lock)
      os_unfair_lock_unlock(&self._bag_lock)
      
      for observer in self._bag {
        observer.onNext(newValue)
      }
    }
  }
  
  deinit {
    #if DEBUG
    ObjectCounter.decrement()
    #endif
  }

  public func subscribe<T>(with observer: T) -> Disposable where T : Observer, KeyPathObservable.Element == T.Element, KeyPathObservable.Failure == T.Failure, KeyPathObservable.Success == T.Success {
    let sink = Sink(targetObserver: observer, subscriptionHandler: { (sinkObserver) -> Disposable in
      do {
        os_unfair_lock_lock(&_lastValue_lock)
        defer {
          os_unfair_lock_unlock(&_lastValue_lock)
        }
        
        if let lastValue = _lastValue {
          sinkObserver.onNext(lastValue)
        }
      }
      
      os_unfair_lock_lock(&_bag_lock)
      defer {
        os_unfair_lock_unlock(&_bag_lock)
      }
      
      let key = _bag.insert(sinkObserver)
      return AnyDisposable(disposeHandler: { [weak self] in
        guard let `self` = self else { return }
        os_unfair_lock_lock(&self._bag_lock)
        defer {
          os_unfair_lock_unlock(&self._bag_lock)
        }
        
        self._bag.removeElement(forKey: key)
      })
    })
    
    return sink
  }
  
}
