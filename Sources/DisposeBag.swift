//
//  DisposeBag.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class DisposeBag {
  
  private var _disposables: [Disposable] = []
  
  private var _lock = os_unfair_lock()
  
  public init() {}
  
  public func add(_ disposable: Disposable) {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    _disposables.append(disposable)
  }
  
  public func disposeAll() {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    for disposable in _disposables {
      disposable.dispose()
    }
    
    _disposables.removeAll()
  }
  
}
