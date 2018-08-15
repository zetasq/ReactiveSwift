//
//  CombineLatest2.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/15.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public final class CombineLatestObservable2<
  O1: Observable,
  O2: Observable>
: Observable {

  public typealias Element = (O1.Element, O2.Element)
  
  public typealias Success = Void
  
  public typealias Failure = NSError // TODO: Use Never
  
  private let _observable1: O1
  private let _observable2: O2
  
  public init(_ observable1: O1, _ observable2: O2) {
    self._observable1 = observable1
    self._observable2 = observable2
  }
  
  public func subscribe<T: Observer>(with observer: T) -> Disposable where T.EventType == CombineLatestObservable2.EventType {
    let sink = _Sink(targetObserver: observer, observable1: _observable1, observable2: _observable2)
    return sink
  }
  
  
}
