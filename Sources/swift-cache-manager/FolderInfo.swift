import Foundation

struct FileInfo : Codable {
  let url : URL
  let created : Date
  let modified : Date
  let size : Int
}

struct FolderInfo : Codable {
  let files : [FileInfo]
  let info : FileInfo
}
