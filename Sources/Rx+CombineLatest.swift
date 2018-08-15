//
//  CombineLatest.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/16.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Rx {
  
  public static func combineLatest<O1: Observable, O2: Observable>(_ observable1: O1, _ observable2: O2) -> CombineLatestObservable2<O1, O2> {
    return CombineLatestObservable2(observable1, observable2)
  }
  
}
