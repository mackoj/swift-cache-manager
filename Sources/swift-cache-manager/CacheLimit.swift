//
//  File.swift
//  
//
//  Created by Jeffrey Macko on 25/09/2019.
//

import Foundation

public enum CacheLimit {
  case size(Int) // in bytes
  case date(Int) // in seconds after creation date
  case dateAndSize(date: Int, size: Int)
  case none
}
