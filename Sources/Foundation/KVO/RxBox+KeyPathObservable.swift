//
//  Boxing+KeyPathObservable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension RxBox where T: _KeyValueCodingAndObserving {
  
  @inlinable
  public func observable<ValueType>(forKeyPath keyPath: KeyPath<T, ValueType>) -> KeyPathObservable<T, ValueType> {
    return obj.keyPathObservablePool.observable(forKeyPath: keyPath)
  }
  
}
