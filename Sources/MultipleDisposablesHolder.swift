//
//  MultipleDisposablesHolder.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class MultipleDisposablesHolder: Disposable {
  
  private var _lock = os_unfair_lock()
  
  private var _disposables: [Disposable] = []
  
  private var _isDisposed = false
  
  public init(disposables: Disposable...) {
    _disposables = disposables
  }
  
  public init(disposables: [Disposable]) {
    _disposables = disposables
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
    
    for disposable in _disposables {
      disposable.dispose()
    }
    
    _disposables.removeAll()
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
    
    _disposables.append(disposable)
  }

}
