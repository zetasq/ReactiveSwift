//
//  AnyObserver.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public struct AnyObserver<Element, Success, Failure: Error>: Observer {

  public typealias EventHandler = (Event<Element, Success, Failure>) -> Void
  
  private let eventHandler: EventHandler
  
  public init(eventHandler: @escaping EventHandler) {
    self.eventHandler = eventHandler
  }
  
  public init<O: Observer>(_ observer: O) where O.EventType == EventType {
    self.init(eventHandler: observer.on)
  }
  
  public func on(_ event: Event<Element, Success, Failure>) {
    eventHandler(event)
  }

}

extension AnyObserver {
  
  public init(nextHandler: @escaping (Element) -> Void) {
    self.init(eventHandler: { event in
      switch event {
      case .next(let element):
        nextHandler(element)
      case .finish:
        break
      }
    })
  }
  
  public init(finishHandler: @escaping (Result<Success, Failure>) -> Void) {
    self.init(eventHandler: { event in
      switch event {
      case .next:
        break
      case .finish(let result):
        finishHandler(result)
      }
    })
  }
  
}
