//
//  Bag.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/4.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public struct BagKey: Hashable {
  
  public let value: UInt
  
  func next() -> BagKey {
    return BagKey(value: value &+ 1)
  }
  
}

struct Bag<Element> {

  private var _table: [BagKey: Element] = [:]
  
  private var _nextKey = BagKey(value: 0)
  
  @discardableResult
  mutating func insert(_ element: Element) -> BagKey {
    let key = _nextKey
    _nextKey = _nextKey.next()
    
    _table[key] = element
    
    return key
  }
  
  @discardableResult
  mutating func removeElement(forKey key: BagKey) -> Element? {
    return _table.removeValue(forKey: key)
  }
  
  mutating func removeAll() {
    _table.removeAll()
  }
  
  var count: Int {
    return _table.count
  }
  
  var isEmpty: Bool {
    return _table.isEmpty
  }
  
}

extension Bag: Sequence {

  func makeIterator() -> AnyIterator<Element> {
    var tableIterater = _table.makeIterator()
    return AnyIterator({ () -> Element? in
      return tableIterater.next()?.value
    })
  }

}
