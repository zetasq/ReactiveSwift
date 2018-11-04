//
//  Observable+Throttle.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/11/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

extension Observable {
  
  
  /// Throttle the events emitted by self on the specified queue with the interval.
  /// An event will be only emitted if the interval has passed since the last emitted event. Every new event is fired after the interval has passed since the original event.
  ///
  /// - Parameters:
  ///   - queue: The queue to debounce on.
  ///   - interval: The time interval for the throttle.
  /// - Returns: A new observable for the throttled event stream.
  @inlinable
  public func throttle(on queue: DispatchQueue, interval: DispatchTimeInterval) -> AnyObservable<Element, Success, Failure> {
    return AnyObservable(subscribeHandler: { (observer) -> Disposable in
      var lastScheduledTime: DispatchTime = .now()
      
      return self.subscribe(with: AnyObserver(eventHandler: { event in
        
        queue.asyncAfter(deadline: .now() + interval) {
          guard lastScheduledTime + interval <= .now() else { return }
          
          lastScheduledTime = .now()
          observer.on(event)
        }
      }))
    })
  }
  
}
