import Foundation

@propertyWrapper
struct Cache<StorageType : Codable> {
  let cacheManager = CacheManager<StorageType>()
  var wrappedValue: StorageType
  let objectID : String?
  
  public mutating func load(_ objectKey : String? = nil) {
    let realKey = objectID ?? objectKey
    if let key = realKey, let val = cacheManager?.load(key) { wrappedValue = val }
  }
  
  public mutating func save(_ objectKey: String? = nil) {
    let realKey = objectID ?? objectKey
    if let key = realKey { cacheManager?.save(wrappedValue, key) }
  }
  
  init(wrappedValue value: StorageType, objectID : String? = nil) {
    self.wrappedValue = value
    self.objectID = objectID
  }
}

