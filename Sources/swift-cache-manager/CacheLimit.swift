import Foundation

public enum CacheLimit {
  case size(Int) // in bytes
  case date(Int) // in seconds after creation date
  case dateAndSize(date: Int, size: Int)
  case none
}
