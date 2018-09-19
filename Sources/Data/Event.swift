//
//  Event.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public enum Event<Element, Success, Failure: Error> {
  
  public typealias ResultType = Result<Success, Failure>

  case next(Element)
  
  case finish(ResultType)
  
  @inlinable
  public func map<E, S, F>(_ transform: (Event) -> Event<E, S, F>) -> Event<E, S, F> {
    return transform(self)
  }
  
  @inlinable
  public func mapElement<E>(_ transform: (Element) -> E) -> Event<E, Success, Failure> {
    switch self {
    case .next(let element):
      return .next(transform(element))
    case .finish(let result):
      return .finish(result)
    }
  }
  
  @inlinable
  public func mapResult<S, F>(_ transform: (ResultType) -> Result<S, F>) -> Event<Element, S, F> {
    switch self {
    case .next(let element):
      return .next(element)
    case .finish(let result):
      return .finish(transform(result))
    }
  }
  
}
