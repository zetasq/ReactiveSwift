//
//  ThreadTracker.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/5.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class ThreadTracker {
  
  private let _lock = NSRecursiveLock()
  
  private var _threadEntryCountTable: [UnsafeMutableRawPointer: Int] = [:]
  
  public func enterThreadExclusiveSection() {
    _lock.lock()
    defer {
      _lock.unlock()
    }
    
    let pointer = Unmanaged.passUnretained(Thread.current).toOpaque()
    let currentThreadEntryCount = _threadEntryCountTable[pointer, default: 0] + 1
    
    if currentThreadEntryCount > 1 {
      assert(false, "Thread reentrancy detected in exclusive section")
    }
    
    _threadEntryCountTable[pointer] = currentThreadEntryCount
    
    if _threadEntryCountTable.count > 1 {
      assert(false, "Thread contension detected in exclusive section")
    }
  }
  
  public func leaveThreadExclusiveSection() {
    _lock.lock()
    defer {
      _lock.unlock()
    }
    
    let pointer = Unmanaged.passUnretained(Thread.current).toOpaque()
    let currentThreadEntryCount = _threadEntryCountTable[pointer, default: 0] - 1
    
    assert(currentThreadEntryCount >= 0)
    
    _threadEntryCountTable[pointer] = currentThreadEntryCount > 0 ? currentThreadEntryCount : nil
  }
  
}
