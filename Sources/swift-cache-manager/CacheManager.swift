//
//  File.swift
//  
//
//  Created by Jeffrey Macko on 25/09/2019.
//

import Foundation

public let ThirtyDaysInSecond : Int = 2_592_000

public class CacheManager<StorageType: Codable> {
  let cacheDirectoryURL: URL
  lazy var folderInfos : FolderInfo? = {
    return CacheManager.getFileInfo(self.cacheDirectoryURL, fileManager: self.fileManager)
  }()
    
  let fileManager : FileManager
  let cacheLimit : CacheLimit
  
  public init?(cacheLimit : CacheLimit = .date(ThirtyDaysInSecond), fileManager : FileManager = FileManager.default) {
    self.fileManager = fileManager
    self.cacheLimit = cacheLimit
    
    do {
      let generalCacheFolderURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      let cacheFolderForStorageType = "\(StorageType.self)_Cache"
      cacheDirectoryURL = generalCacheFolderURL.appendingPathComponent(cacheFolderForStorageType)
      try purgeCache()
    } catch {
      print(error)
      return nil
    }
  }
  
  public func load(_ objectID: String) -> StorageType? {
    let fileURL = cacheDirectoryURL.appendingPathComponent(objectID)
    guard fileManager.isReadableFile(atPath: fileURL.absoluteString) else {
      print("File not readable")
      return nil
    }
    
    do {
      let data = try Data(contentsOf: fileURL)
      let obj = try JSONDecoder().decode(StorageType.self, from: data)
      return obj
    } catch {
      print(error)
    }
    return nil
  }
  
  public func save(_ obj: StorageType, _ key: String, options writingOptions: Data.WritingOptions = [.atomicWrite, .completeFileProtection]) {
    let fileURL = cacheDirectoryURL.appendingPathComponent(key)
    guard fileManager.isWritableFile(atPath: cacheDirectoryURL.absoluteString) else {
      print("Folder is not writable")
      return
    }
    
    do {
      let data = try JSONEncoder().encode(obj)
      try data.write(to: fileURL, options: writingOptions)
    } catch {
      print(error)
    }
  }
}

