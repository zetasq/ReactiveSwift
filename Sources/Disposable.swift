//
//  Disposable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public protocol Disposable {
  
  func dispose()
  
  var isDisposed: Bool { get }
  
}
