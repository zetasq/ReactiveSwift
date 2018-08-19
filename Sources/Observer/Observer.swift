//
//  Observer.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/3.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public protocol Observer {
  
  associatedtype Element
  
  associatedtype Success
  
  associatedtype Failure: Error
  
  func on(_ event: EventType)

}

extension Observer {
  
  public typealias EventType = Event<Element, Success, Failure>
  
  public func onNext(_ element: Element) {
    on(.next(element))
  }
  
  public func onFinish(_ result: EventType.ResultType) {
    on(.finish(result))
  }
  
}
