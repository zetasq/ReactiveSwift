//
//  SingleDisposableHolder.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 14/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class SingleDisposableHolder: Disposable {
  
  private var _lock = os_unfair_lock()
  
  private var _disposable: Disposable?
  
  private var _isDisposed = false
  
  private var _isUsed = false
  
  public init() {}
  
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
    
    _disposable?.dispose()
    _disposable = nil
  }
  
  public func hold(_ disposable: Disposable) {
    precondition(!_isUsed)
    _isUsed = true
    
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    guard !_isDisposed else {
      disposable.dispose()
      return
    }
    
    _disposable = disposable
  }
  
}
