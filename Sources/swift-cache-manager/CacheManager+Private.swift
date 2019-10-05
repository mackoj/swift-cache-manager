import Foundation

extension CacheManager {
  
  func directoryExistsAtPath(_ url: URL) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
  }
  
  static func getFileInfo(_ folderURL :  URL, fileManager : FileManager = FileManager.default) -> FolderInfo? {
    do {
      
      /// Files
      let fileURLs = try fileManager.contentsOfDirectory(
        at: folderURL,
        includingPropertiesForKeys: [kCFURLCreationDateKey as URLResourceKey, kCFURLContentAccessDateKey as URLResourceKey, kCFURLContentModificationDateKey as URLResourceKey],
        options: .skipsHiddenFiles
      )
      var files : [FileInfo] = []
      for fileURL in fileURLs {
        let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
        let fileInfo = FileInfo(
          url: fileURL,
          created: attributes[.creationDate] as! Date,
          modified: attributes[.modificationDate] as! Date,
          size: attributes[.size] as! Int
        )
        files.append(fileInfo)
      }
      
      /// Folder
      let attributes = try fileManager.attributesOfItem(atPath: folderURL.path)
      let fileInfo = FileInfo(
        url: folderURL,
        created: attributes[.creationDate] as! Date,
        modified: attributes[.modificationDate] as! Date,
        size: attributes[.size] as! Int
      )
      
      return FolderInfo(files: files, info: fileInfo)
    } catch {
      print(error.localizedDescription)
    }
    return nil
  }
  
  private func removeFileBySize(_ fileSizeLimit : Int) throws {
    guard let localFolderInfos = folderInfos else { return }
    
    if localFolderInfos.info.size > fileSizeLimit {
      let localFolderInfosFilesSize = localFolderInfos.files.reduce(0, { (r, f) in
        return r + f.size
      })
      var diff = localFolderInfosFilesSize - fileSizeLimit
      if diff > 0 {
        let filesInfos = localFolderInfos.files.sorted(by: \.created) // les plus vieux en premier ?
        for aFile in filesInfos {
          try fileManager.removeItem(at: aFile.url)
          diff -= aFile.size
          if diff <= 0 { break }
        }
      }
    }
    folderInfos = CacheManager.getFileInfo(self.cacheDirectoryURL, fileManager: self.fileManager)
  }
  
  private func removeFileByDate(_ expirationInSecond : Int) throws {
    guard let localFolderInfos = folderInfos else { return }
    
    let filesInfos = localFolderInfos.files.sorted(by: \.created) // les plus vieux en premier ?
    let now = Date()
    if let maxDate = Calendar.autoupdatingCurrent.date(byAdding: .second, value: -expirationInSecond, to: now) {
      for aFile in filesInfos {
        if aFile.created < maxDate { try fileManager.removeItem(at: aFile.url) }
      }
    }
    folderInfos = CacheManager.getFileInfo(self.cacheDirectoryURL, fileManager: self.fileManager)
  }
  
  public func purgeCache() throws {
    for limit in self.cacheLimit {
      switch limit {
      case let .size(fileSize): try removeFileBySize(fileSize)
      case let .secondsAfterCreationDate(expirationInSecond): try removeFileByDate(expirationInSecond)
      }
    }
  }
}
