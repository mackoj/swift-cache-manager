import Foundation

//extension String {
//  static func hashableString<Type : Hashable>(_ hash : Type) -> String {
//    return "\(hash.hashValue)"
//  }
//}

extension Sequence {
  func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
    return sorted { a, b in
      return a[keyPath: keyPath] < b[keyPath: keyPath]
    }
  }
}
