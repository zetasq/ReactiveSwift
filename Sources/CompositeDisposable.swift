//
//  CompositeDisposable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class CompositeDisposable: Disposable {
  
  private var _lock = os_unfair_lock()
  
  private var _disposableBag = Bag<Disposable>()
  
  private var _isDisposed = false
  
  public init(disposables: Disposable...) {
    for disposable in disposables {
      _disposableBag.insert(disposable)
    }
  }
  
  public init(disposables: [Disposable]) {
    for disposable in disposables {
      _disposableBag.insert(disposable)
    }
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
    
    for disposable in _disposableBag {
      disposable.dispose()
    }
    
    _disposableBag.removeAll()
  }
  
  public var count: Int {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    return _disposableBag.count
  }
  
  @discardableResult
  public func insert(_ disposable: Disposable) -> BagKey? {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    guard !_isDisposed else {
      disposable.dispose()
      return nil
    }
    
    return _disposableBag.insert(disposable)
  }
  
  @discardableResult
  public func remove(for disposeKey: BagKey) -> Disposable? {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    guard let disposable = _disposableBag.removeElement(forKey: disposeKey) else {
      return nil
    }

    disposable.dispose()
    return disposable
  }
}
