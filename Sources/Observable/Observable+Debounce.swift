//
//  Observable+Debounce.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/11/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {
  
  
  /// Debounce the events emitted by self on the specified queue with the interval.
  /// An event will be only emitted if no new events are emitted from the current observable when the interval has passed.
  ///
  /// - Parameters:
  ///   - queue: The queue to debounce on.
  ///   - interval: The time interval for the debounce.
  /// - Returns: A new observable for the debounced event stream.
  @inlinable
  public func debounce(on queue: DispatchQueue, interval: DispatchTimeInterval) -> AnyObservable<Element, Success, Failure> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      var pendingWorkItem: DispatchWorkItem?

      return self.subscribe(with: AnyObserver(eventHandler: { event in
        pendingWorkItem?.cancel()
        
        pendingWorkItem = DispatchWorkItem(block: {
          observer.on(event)
        })
        
        queue.asyncAfter(deadline: .now() + interval, execute: pendingWorkItem!)
      }))
    })
  }
  
}
