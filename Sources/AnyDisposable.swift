//
//  AnyDisposable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class AnyDisposable: Disposable {
  
  private let disposeHandler: () -> Void
  
  public init(disposeHandler: @escaping () -> Void) {
    self.disposeHandler = disposeHandler
  }
  
  public func dispose() {
    disposeHandler()
  }
  
  
}
