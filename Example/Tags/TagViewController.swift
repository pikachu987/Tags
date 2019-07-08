//
//  TagViewController.swift
//  Tags_Example
//
//  Created by APPLE on 24/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Tags

class TagViewController: UIViewController {
    var tags: [String]?
    
    private let tagsView: TagsView = {
        let view = TagsView(width: UIScreen.main.bounds.width - 40)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tagsView)
        let itemView = self.view as Any
        self.view.addConstraints([
            NSLayoutConstraint(item: itemView, attribute: .trailing, relatedBy: .equal, toItem: self.tagsView, attribute: .trailing, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: itemView, attribute: .leading, relatedBy: .equal, toItem: self.tagsView, attribute: .leading, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: itemView, attribute: .top, relatedBy: .equal, toItem: self.tagsView, attribute: .top, multiplier: 1, constant: -(self.navigationController?.navigationBar.frame.height ?? 0) - UIApplication.shared.statusBarFrame.height),
            NSLayoutConstraint(item: itemView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.tagsView, attribute: .bottom, multiplier: 1, constant: 0),
            ])
        
        self.tagsView.delegate = self
        self.tagsView.marginHorizontal = 2
        self.tagsView.marginVertical = 0
        self.tagsView.paddingHorizontal = 0
        self.tagsView.paddingVertical = 0
        
        if let tags = self.tags?.compactMap({ self.makeButton($0) }) {
            self.tagsView.set(contentsOf: tags)
        }
    }
    
    private func makeButton(_ item: String) -> TagButton {
        let button = TagButton(type: .system)
        button.setTitle(item, for: .normal)
        button.setEntity(
            ButtonOptions(
                layerColor: .clear,
                layerRadius: 0,
                layerWidth: 0,
                tagTitleColor: UIColor(red: 100/255, green: 113/255, blue: 136/255, alpha: 1),
                tagFont: UIFont.systemFont(ofSize: 13),
                tagBackgroundColor: .clear,
                lineBreakMode: NSLineBreakMode.byTruncatingTail
            )
        )
        return button
    }
}

// MARK: TagsDelegate
extension TagViewController: TagsDelegate {
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
        
    }
}
