import Foundation

extension CacheManager {
  
  func directoryExistsAtPath(_ url: URL) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
  }

  static func getFileInfo(_ folder :  URL, fileManager : FileManager = FileManager.default) -> FolderInfo? {
    do {
      let fileURLs = try fileManager.contentsOfDirectory(
        at: folder,
        includingPropertiesForKeys: [kCFURLCreationDateKey as URLResourceKey, kCFURLContentAccessDateKey as URLResourceKey, kCFURLContentModificationDateKey as URLResourceKey],
        options: .skipsHiddenFiles
      )
      var files : [FileInfo] = []
      for fileURL in fileURLs {
        let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
        let fileInfo = FileInfo(
          path: fileURL,
          created: attributes[.creationDate] as! Date,
          modified: attributes[.modificationDate] as! Date,
          size: attributes[.size] as! Int
        )
        files.append(fileInfo)
      }
      
      let attributes = try fileManager.attributesOfItem(atPath: folder.path)
      let fileInfo = FileInfo(
        path: folder,
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
      var diff = localFolderInfos.info.size - fileSizeLimit
      let filesInfos = localFolderInfos.files.sorted(by: \.created) // les plus vieux en premier ?
      for aFile in filesInfos {
        try fileManager.removeItem(at: aFile.path)
        diff -= aFile.size
        if diff <= 0 { break }
      }
    }
    folderInfos = CacheManager.getFileInfo(self.cacheDirectoryURL, fileManager: self.fileManager)
  }

  private func removeFileByDate(_ expirationInSecond : Int) throws {
    guard let localFolderInfos = folderInfos else { return }
    
    let filesInfos = localFolderInfos.files.sorted(by: \.created) // les plus vieux en premier ?
    if let maxDate = Calendar.autoupdatingCurrent.date(byAdding: .second, value: -expirationInSecond, to: Date()) {
      for aFile in filesInfos {
        if aFile.created > maxDate { try fileManager.removeItem(at: aFile.path) }
      }
    }
    folderInfos = CacheManager.getFileInfo(self.cacheDirectoryURL, fileManager: self.fileManager)
  }

  func purgeCache() throws {
    switch self.cacheLimit {
    case let .size(fileSize): try removeFileBySize(fileSize)
    case let .date(expirationInSecond): try removeFileByDate(expirationInSecond)
    case let .dateAndSize(expirationInSecond, fileSize):
      try removeFileBySize(fileSize)
      try removeFileByDate(expirationInSecond)
    case .none: break
    }
  }
}
