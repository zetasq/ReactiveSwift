//
//  AnyDisposable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class AnyDisposable: Disposable {
  
  private let disposeHandler: () -> Void
  
  private var _isDisposed = false
  
  private var _lock = os_unfair_lock()
  
  public init(disposeHandler: @escaping () -> Void) {
    self.disposeHandler = disposeHandler
  }
  
  public func dispose() {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    guard !_isDisposed else {
      return
    }
    
    disposeHandler()
    
    _isDisposed = true
  }
  
  public var isDisposed: Bool {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    return _isDisposed
  }
  
}
