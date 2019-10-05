import Foundation

public let ThirtyDaysInSecond : Int = 2_592_000

public class CacheManager<StorageType: Codable> {
  public let cacheDirectoryURL: URL
  #if os(iOS)
  let dataWritingOptions : Data.WritingOptions = [
    .atomicWrite,
    .completeFileProtection
  ]
  #else
  let dataWritingOptions : Data.WritingOptions = [
    .atomicWrite,
  ]
  #endif
  
  lazy var folderInfos : FolderInfo? = {
    return CacheManager.getFileInfo(self.cacheDirectoryURL, fileManager: self.fileManager)
  }()
  
  let fileManager : FileManager
  let cacheLimit : [CacheLimit]
    
  public init?(cacheLimit : [CacheLimit] = [.secondsAfterCreationDate(ThirtyDaysInSecond)], fileManager : FileManager = FileManager.default) {
    self.fileManager = fileManager
    self.cacheLimit = cacheLimit
    
    do {
      let generalCacheFolderURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      let cacheFolderForStorageType = "\(StorageType.self)_Cache_\(UUID().uuidString)"
      cacheDirectoryURL = generalCacheFolderURL.appendingPathComponent(cacheFolderForStorageType)
      if directoryExistsAtPath(cacheDirectoryURL) == false {
        try fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: false, attributes: nil)
      }
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
  
  public func loadAll() -> [StorageType] {
    do {
      try purgeCache()
      var result : [StorageType] = []
      let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
      for fileURL in fileURLs {
        if let obj = load(fileURL) {
          result.append(obj)
        }
      }
      return result
    } catch {
      print(error.localizedDescription)
    }
    return []
  }
  
  func load(_ fileURL: URL) -> StorageType? {
    do {
      let data = try Data(contentsOf: fileURL)
      let obj = try JSONDecoder().decode(StorageType.self, from: data)
      return obj
    } catch {
      print(error.localizedDescription)
    }
    return nil
  }
  
  public func load(_ key: String) -> StorageType? {
    do { try purgeCache() }
    catch { print(error) }

    let fileURL = cacheDirectoryURL.appendingPathComponent("\(key).json")
    return load(fileURL)
  }
    
  public func save(_ obj: StorageType, _ key: String, options writingOptions: Data.WritingOptions? = nil) {
    let fileURL = cacheDirectoryURL.appendingPathComponent("\(key).json")
    
    do {
      let data = try JSONEncoder().encode(obj)
      let option = writingOptions ?? dataWritingOptions
      try data.write(to: fileURL, options: option)
      try purgeCache()
    } catch {
      print(error.localizedDescription)
    }
  }
}

