import Foundation


/// Helpers
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
}
