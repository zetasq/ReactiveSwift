//
//  Disposable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public protocol Disposable: AnyObject {
  
  func dispose()
  
  var isDisposed: Bool { get }
  
}

extension Disposable {
  
  @inlinable
  public func add(to disposeBag: DisposeBag) {
    disposeBag.add(self)
  }
  
}
