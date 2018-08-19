//
//  Boxing+Observable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension KeyValueObjectBox where T: AnyObject {
  
  public func observable<ValueType>(forKeyPath keyPath: KeyPath<T, ValueType>) -> KeyPathObservable<T, ValueType> {
    return obj.keyPathObservablePool.observable(forKeyPath: keyPath)
  }
  
}
