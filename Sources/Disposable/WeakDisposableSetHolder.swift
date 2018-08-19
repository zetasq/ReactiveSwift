//
//  WeakDisposableSetHolder.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class WeakDisposableSetHolder: Disposable {
  
  private var _lock = os_unfair_lock()
  
  private let _disposableTable = NSHashTable<AnyObject>.weakObjects()
  
  private var _isDisposed = false
  
  public init() {
    #if DEBUG
    ObjectCounter.increment()
    #endif
  }
  
  deinit {
    #if DEBUG
    ObjectCounter.decrement()
    #endif
  }
  
  public var isDisposed: Bool {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    return _isDisposed
  }
  
  public func dispose() {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    _isDisposed = true
    
    for obj in _disposableTable.objectEnumerator() {
      (obj as! Disposable).dispose()
    }

    _disposableTable.removeAllObjects()
  }

  public func hold(_ disposable: Disposable) {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    guard !_isDisposed else {
      disposable.dispose()
      return
    }
    
    _disposableTable.add(disposable)
  }

}
