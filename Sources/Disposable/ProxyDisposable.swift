//
//  ProxyDisposable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/19.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

internal protocol ProxyDisposableDelegate: AnyObject {
  
  func proxyDisposableRequestDispose(_ disposable: ProxyDisposable)
  
}

internal final class ProxyDisposable: Hashable, Disposable {

  internal weak var delegate: ProxyDisposableDelegate?
  
  private var _isDisposed = false
  
  private var _lock = os_unfair_lock()
  
  internal init() {
    #if DEBUG
    ObjectCounter.increment()
    #endif
  }
  
  deinit {
    #if DEBUG
    ObjectCounter.decrement()
    #endif
  }
  
  // MARK: - Disposable
  internal var isDisposed: Bool {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    return _isDisposed
  }
  
  internal func dispose() {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    guard !_isDisposed else {
      return
    }
    
    delegate?.proxyDisposableRequestDispose(self)
    
    _isDisposed = true
  }
  
  // MARK: - Hashable
  @inlinable
  public var hashValue: Int {
    return ObjectIdentifier(self).hashValue
  }
  
  @inlinable
  public static func == (lhs: ProxyDisposable, rhs: ProxyDisposable) -> Bool {
    return lhs === rhs
  }
  
}
