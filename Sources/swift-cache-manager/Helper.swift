//
//  File.swift
//  
//
//  Created by Jeffrey Macko on 25/09/2019.
//

import Foundation

extension Sequence {
  func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
    return sorted { a, b in
      return a[keyPath: keyPath] < b[keyPath: keyPath]
    }
  }
}
