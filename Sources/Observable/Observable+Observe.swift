//
//  Observable+Observe.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {
  
  @inlinable
  @discardableResult
  public func subscribeOnEvent(_ eventHandler: @escaping (EventType) -> Void) -> Disposable {
    return self.subscribe(with: AnyObserver(eventHandler: eventHandler))
  }
  
  @inlinable
  @discardableResult
  public func subscribeOnNext(_ nextHandler: @escaping (Element) -> Void) -> Disposable {
    return self.subscribe(with: AnyObserver(nextHandler: nextHandler))
  }
  
  @inlinable
  @discardableResult
  public func subscribeOnFinish(_ finishHandler: @escaping (EventType.ResultType) -> Void) -> Disposable {
    return self.subscribe(with: AnyObserver(finishHandler: finishHandler))
  }
  
}
