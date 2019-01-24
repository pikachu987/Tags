//
//  TagCell.swift
//  Tags_Example
//
//  Created by Gwanho Kim on 04/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Tags

class TagCell: UITableViewCell {
    static let identifier = "TagCell"
    
    @IBOutlet private weak var tagsView: TagsView!
    
    var tags: [String]? {
        willSet {
            if let newValue = newValue {
                self.tagsView.set(contentsOf: newValue)
            } else {
                self.tagsView.removeTags()
            }
        }
    }
    
    var tagButton: [TagButton]? {
        willSet {
            if let newValue = newValue {
                self.tagsView.set(contentsOf: newValue)
            } else {
                self.tagsView.removeTags()
            }
        }
    }
    
    var lastTag: String? {
        willSet {
            self.tagsView.lastTag = newValue
        }
    }
    
    var lastTagButton: TagButton? {
        willSet {
            if let newValue = newValue {
                self.tagsView.lastTagButton(newValue)
            } else {
                self.tagsView.removeLastTag()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.tagsView.delegate = self
        self.tagsView.width = UIScreen.main.bounds.width - 20
    }
}

// MARK: TagsDelegate
extension TagCell: TagsDelegate {
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
        print("Click Tag! \(self)")
    }
    
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
        print("Click LastTag! \(self)")
    }
}
