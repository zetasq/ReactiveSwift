//
//  ObjectCounter.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/5.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public enum ObjectCounter {
  
  private static var _count: Int = 0
  
  private static var _lock = os_unfair_lock()
  
  public static func increment() {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    _count += 1
  }
  
  public static func decrement() {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    _count -= 1
  }
  
  public static var currentCount: Int {
    os_unfair_lock_lock(&_lock)
    defer {
      os_unfair_lock_unlock(&_lock)
    }
    
    return _count
  }
  
}
