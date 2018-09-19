//
//  ControlEventObservablePool.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/26.
//  Copyright © 2018 zetasq. All rights reserved.
//

#if os(iOS)

import UIKit

private var controlEventObservablePoolKey = "keyPathObservablePoolKey"

// We cannot extend AnyObject (due to explicit restriction by Swift designer), so we extend _KeyValueCodingAndObserving here.
extension _KeyValueCodingAndObserving where Self: UIControl {
  
  internal var controlEventObservablePool: ControlEventObservablePool<Self> {
    assert(Thread.isMainThread)
    
    if let existingPool = objc_getAssociatedObject(self, &controlEventObservablePoolKey) as? ControlEventObservablePool<Self> {
      return existingPool
    } else {
      let newPool = ControlEventObservablePool(control: self)
      objc_setAssociatedObject(self, &controlEventObservablePoolKey, newPool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return newPool
    }
  }
  
}

extension UIControl.Event: Hashable {
  
  public var hashValue: Int {
    return self.rawValue.hashValue
  }
  
  public static func ==(lhs: UIControl.Event, rhs: UIControl.Event) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
  
}

public final class ControlEventObservablePool<ControlType: UIControl> {
  
  private unowned let control: ControlType
  
  private var _observableTable: [UIControl.Event: ControlEventObservable<ControlType>] = [:]
  
  internal init(control: ControlType) {
    assert(Thread.isMainThread)
    
    #if DEBUG
    ObjectCounter.increment()
    #endif
    
    self.control = control
  }
  
  deinit {
    #if DEBUG
    ObjectCounter.decrement()
    #endif
  }
  
  public func observable(forControlEvent controlEvent: UIControl.Event) -> ControlEventObservable<ControlType> {
    assert(Thread.isMainThread)
    
    if let observable = _observableTable[controlEvent] {
      return observable
    } else {
      let observable = ControlEventObservable(control: self.control, controlEvent: controlEvent)
      _observableTable[controlEvent] = observable
      return observable
    }
  }
  
}

#endif
