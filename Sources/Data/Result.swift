//
//  Result.swift
//  ReactiveSwift
//
//  Created by Zhu Shengqi on 2018/8/3.
//  Copyright © 2018 zetasq. All rights reserved.
//

import Foundation

public enum Result<Success, Failure: Error> {
  
  case success(Success)
  
  case failure(Failure)
  
}


