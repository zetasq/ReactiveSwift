//
//  Observable+Observe.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 15/8/2018.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {
  
  @discardableResult
  public func subscribeOnEvent(_ eventHandler: @escaping (EventType) -> Void) -> Disposable {
    return self.subscribe(with: AnyObserver(eventHandler: eventHandler))
  }
                                                                                                                                                                                                                                                                                                                                                                                                                                            
  @discardableResult
  public func subscribeOnNext(_ nextHandler: @escaping (Element) -> Void) -> Disposable {
    return self.subscribe(with: AnyObserver(nextHandler: nextHandler))
  }
  
  @discardableResult
  public func subscribeOnFinish(onFinish finishHandler: @escaping (EventType.ResultType) -> Void) -> Disposable {
    return self.subscribe(with: AnyObserver(finishHandler: finishHandler))
  }
  
}
