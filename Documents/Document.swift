//
//  Document.swift
//  Documents
//
//  Created by Grant Maloney on 8/26/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation

let dateFormatter = DateFormatter()

struct Document: Codable {
    let noteTitle: String
    let noteContents: String
    
    private enum CodingKeys: String, CodingKey {
        case noteTitle = "note_title"
        case noteContents = "note_contents"
    }
}

struct Note {
    let noteTitle: String
    let noteSize: String
    let dateModified: String
    let noteContents: String
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var modificationDate: Date? {
        return attributes?[.modificationDate] as? Date
    }
}
