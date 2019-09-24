//
//  File.swift
//  
//
//  Created by Jeffrey Macko on 25/09/2019.
//

import Foundation

struct FileInfo : Codable {
  let path : URL
  let created : Date
  let modified : Date
  let size : Int
}

struct FolderInfo : Codable {
  let files : [FileInfo]
  let info : FileInfo
}
