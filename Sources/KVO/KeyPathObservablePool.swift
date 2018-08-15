//
//  KeyPathObservablePool.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

private var keyPathObservablePoolKey = "keyPathObservablePoolKey"

extension _KeyValueCodingAndObserving where Self: AnyObject {

  internal var keyPathObservablePool: KeyPathObservablePool<Self> {
    objc_sync_enter(self)
    defer {
      objc_sync_exit(self)
    }
    
    if let existingPool = objc_getAssociatedObject(self, &keyPathObservablePoolKey) as? KeyPathObservablePool<Self> {
      return existingPool
    } else {
      let newPool = KeyPathObservablePool(object: self)
      objc_setAssociatedObject(self, &keyPathObservablePoolKey, newPool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return newPool
    }
  }
  
}

public final class KeyPathObservablePool<RootType: AnyObject & _KeyValueCodingAndObserving> {
  
  private unowned let object: RootType
  
  private var _observableTable: [PartialKeyPath<RootType>: AnyObject] = [:]
  private var _lock = os_unfair_lock()
  
  internal init(object: RootType) {
    self.object = object
  }
  
  public func observable<ValueType>(forKeyPath keyPath: KeyPath<RootType, ValueType>) -> KeyPathObservable<RootType, ValueType> {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    if let object = _observableTable[keyPath] {
      return object as! KeyPathObservable<RootType, ValueType>
    } else {
      let observable = KeyPathObservable(object: object, keyPath: keyPath)
      _observableTable[keyPath] = observable
      return observable
    }
  }
  
}
