//
//  File.swift
//  
//
//  Created by Jeffrey Macko on 05/10/2019.
//

import Foundation

/// Purge
extension CacheManager {
  
  func purgeCache() throws {
    for limit in self.cacheLimit {
      switch limit {
      case let .size(fileSize): try removeFileBySize(fileSize)
      case let .secondsAfterCreationDate(expirationInSecond): try removeFileByDate(expirationInSecond)
      }
    }
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
}
