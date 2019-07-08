//
//  TagTableViewController.swift
//  Tags_Example
//
//  Created by Gwanho Kim on 04/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Tags

class TagTableViewController: UIViewController {
    var tags: [String]?
    
    private var tempTags: [String]?
    
    private var isLastTag = true
    
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tempTags = self.tags
        
        self.tableView.register(UINib(nibName: TagCell.identifier, bundle: nil), forCellReuseIdentifier: TagCell.identifier)
        self.tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(self.options(_:)))
    }
    
    @objc private func options(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "Select", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "TagsRemove", style: .default, handler: { (_) in
            self.tags = nil
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "TagsRecovery", style: .default, handler: { (_) in
            self.tags = self.tempTags
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "LastTagRemove", style: .default, handler: { (_) in
            self.isLastTag = false
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "LastTagsRecovery", style: .default, handler: { (_) in
            self.isLastTag = true
            self.tableView.reloadData()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func makeButton(_ text: String) -> TagButton {
        let button = TagButton()
        button.setTitle(text, for: .normal)
        let options = ButtonOptions(
            layerColor: UIColor.brown,
            layerRadius: 10,
            layerWidth: 2,
            tagTitleColor: UIColor(white: 89/255, alpha: 1),
            tagFont: UIFont.boldSystemFont(ofSize: 15),
            tagBackgroundColor: UIColor.white)
        button.setEntity(options)
        return button
    }
    
    private func makeLastTagButton() -> TagButton {
        let button = TagButton()
        button.setTitle("Add Tags", for: .normal)
        let options = ButtonOptions(
            layerColor: UIColor.orange,
            layerRadius: 10,
            layerWidth: 2,
            tagTitleColor: UIColor.orange,
            tagFont: UIFont.boldSystemFont(ofSize: 15),
            tagBackgroundColor: UIColor.white)
        button.setEntity(options)
        return button
    }
}

extension TagTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { fatalError() }
        if indexPath.row == 0 {
            cell.tags = self.tags
            cell.lastTag = self.isLastTag ? "Hi" : nil
        } else if indexPath.row == 1 {
            cell.tagButton = self.tags?.compactMap({ self.makeButton($0) })
            cell.lastTagButton = self.isLastTag ? self.makeLastTagButton() : nil
        } else if indexPath.row == 2 {
            cell.tags = self.tags
        } else if indexPath.row == 3 {
            cell.tagButton = self.tags?.compactMap({ self.makeButton($0) })
        } else {
            cell.tags = self.tags
        }
        return cell
    }
}
