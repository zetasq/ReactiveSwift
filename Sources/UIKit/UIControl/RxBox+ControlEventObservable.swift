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
  
  public func observable(forControlEvent controlEvent: UIControlEvents) -> ControlEventObservable<T> {
    return obj.controlEventObservablePool.observable(forControlEvent: controlEvent)
  }
  
}

#endif
