//
//  Boxing.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public struct KeyValueObjectBox<T: AnyObject & _KeyValueCodingAndObserving> {
  
  internal let obj: T
  
}

extension _KeyValueCodingAndObserving where Self: AnyObject {
  
  public var rx: KeyValueObjectBox<Self> {
    return KeyValueObjectBox(obj: self)
  }
  
}
