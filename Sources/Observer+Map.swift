//
//  Observer+Map.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observer {
  
  public func createBindingObserver<E, S, F: Error>(_ transform: @escaping (Event<E, S, F>) -> EventType) -> AnyObserver<E, S, F> {
    return AnyObserver(eventHandler: { (event) in
      self.on(event.map(transform))
    })
  }
  
  
  
}
