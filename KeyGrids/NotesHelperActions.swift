//
//  NotesHelperActions.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

var notes: [Note] = [Note()]

func readNotesFile() {
    let filePath = Bundle.main.path(forResource:"notes", ofType: "txt")
    let contentData = FileManager.default.contents(atPath: filePath!)
    
    if let content = String(data:contentData!, encoding:String.Encoding.utf8) {
        let rows = content.components(separatedBy: .newlines).filter({ (string) -> Bool in
            return !string.isEmpty
        })
        for row in rows {
            let columns = row.components(separatedBy: .whitespaces)
            let note = Note(name: columns.first!,
                            index: UInt8(columns.last!)!,
                            color: UIColor(hue: CGFloat(notes.count)/CGFloat(rows.count), saturation: 1, brightness: 1, alpha: 1))
            notes.append(note)
        }
    }
}
