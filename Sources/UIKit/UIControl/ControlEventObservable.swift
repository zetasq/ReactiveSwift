//
//  ControlEventObservable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/26.
//  Copyright © 2018 zetasq. All rights reserved.
//

#if os(iOS)

import UIKit

// We need to make ControlEventObservable's superclass as NSObject, otherwise there is a crash when we call allTargets on a UIControl in Swift
public final class ControlEventObservable<ControlType: UIControl>: NSObject, Observable {
  
  public typealias Element = ControlType
  
  public typealias Success = Never
  
  public typealias Failure = NSError // TODO: Use Never
  
  private var _disposableToSinkTable: [ProxyDisposable: Sink<Element, Success, Failure>] = [:]
  private var _tableLock = os_unfair_lock()
  
  internal init(control: ControlType, controlEvent: UIControlEvents) {
    assert(Thread.isMainThread)
    #if DEBUG
    ObjectCounter.increment()
    #endif
    
    super.init()
    
    control.addTarget(self, action: #selector(self.controlEventsFired(_:)), for: controlEvent)
  }
  
  deinit {
    #if DEBUG
    ObjectCounter.decrement()
    #endif
  }
  
  @objc
  private func controlEventsFired(_ sender: Any) {
    os_unfair_lock_lock(&_tableLock)
    defer {
      os_unfair_lock_unlock(&_tableLock)
    }
    
    for sink in self._disposableToSinkTable.values {
      sink.forward(event: .next(sender as! ControlType))
    }
  }
  
  public func subscribe<T>(with observer: T) -> Disposable
    where T : Observer,
    ControlEventObservable.Element == T.Element,
    ControlEventObservable.Success == T.Success,
    ControlEventObservable.Failure == T.Failure {
      
      assert(Thread.isMainThread)
      
      os_unfair_lock_lock(&_tableLock)
      defer {
        os_unfair_lock_unlock(&_tableLock)
      }
      
      let disposable = ProxyDisposable()
      disposable.delegate = self
      
      let sink = Sink(targetObserver: observer)
      _disposableToSinkTable[disposable] = sink
      
      sink.setOriginalDisposable(disposable)
      
      return sink
  }
  
}

extension ControlEventObservable: ProxyDisposableDelegate {
  
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

#endif
