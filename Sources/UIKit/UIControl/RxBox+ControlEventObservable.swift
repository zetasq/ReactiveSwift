//
//  RxBox+ControlEventObservable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/26.
//  Copyright © 2018 zetasq. All rights reserved.
//

#if os(iOS)

import UIKit

extension RxBox where T: UIControl {
  
  @inlinable
  public func observable(forControlEvent controlEvent: UIControl.Event) -> ControlEventObservable<T> {
    return obj.controlEventObservablePool.observable(forControlEvent: controlEvent)
  }
  
}

#endif
