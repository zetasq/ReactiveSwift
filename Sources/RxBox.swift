//
//  RxBox.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/26.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public struct RxBox<T: AnyObject> {
  
  @usableFromInline
  internal let obj: T
  
  @usableFromInline
  internal init(obj: T) {
    self.obj = obj
  }
  
}

// We cannot extend AnyObject (due to explicit restriction by Swift designer), so we extend _KeyValueCodingAndObserving here.
extension _KeyValueCodingAndObserving where Self: AnyObject {
  
  @inlinable
  public var rx: RxBox<Self> {
    return RxBox(obj: self)
  }
  
}
