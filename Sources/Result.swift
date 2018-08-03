//
//  Result.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/3.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public enum Result<T, E: Error> {
  
  case success(T)
  
  case failure(E)
  
}


