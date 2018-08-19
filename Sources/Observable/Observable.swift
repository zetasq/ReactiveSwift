//
//  Observable.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/3.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public protocol Observable {
  
  associatedtype Element
  
  associatedtype Success
  
  associatedtype Failure: Error
  
  func subscribe<T: Observer>(with observer: T) -> Disposable where T.EventType == Self.EventType
  
}

extension Observable {
  
  public typealias EventType = Event<Element, Success, Failure>
  
}
