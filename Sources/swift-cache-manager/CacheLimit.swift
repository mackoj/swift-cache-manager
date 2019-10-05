import Foundation

public enum CacheLimit {

  // in bytes
  case size(Int)
  
  // in seconds after creation date
  case secondsAfterCreationDate(Int)
}
