//Copyright (c) 2018 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.


import UIKit

public protocol TagsDelegate: class {
    /// When you touch the button, the function is called.
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton)
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton)
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat)
}

public extension TagsDelegate {
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) { }
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) { }
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) { }
}

public class TagDefaultOption {
    public static var paddingHorizontal: CGFloat = 6
    public static let paddingVertical: CGFloat = 4
    public static var marginHorizontal: CGFloat = 6
    public static var marginVertical: CGFloat = 4
    public static var tagLayerColor: UIColor = .black
    public static var tagLayerRadius: CGFloat = 6
    public static var tagLayerWidth: CGFloat = 1
    public static var tagTitleColor: UIColor = .black
    public static var tagFont: UIFont = UIFont.systemFont(ofSize: 15)
    public static var tagBackgroundColor: UIColor = .white
    public static var lineBreakMode: NSLineBreakMode = .byTruncatingMiddle
    public static var lastTagTitleColor: UIColor = .blue
    public static var lastTagLayerColor: UIColor = .blue
    public static var lastTagBackgroundColor: UIColor = .white
}


@IBDesignable
public class TagsView: UIView {
    public weak var delegate: TagsDelegate?
    
    // MARK: var
    private var _tagArray = [TagButton]()
    
    public var tagArray: [TagButton] {
        get {
            return self._tagArray.map({ $0 })
        }
    }
    
    public var tagTextArray: [String] {
        get {
            return self._tagArray.compactMap({ $0.currentTitle })
        }
    }
    
    public var width: CGFloat = 0 {
        didSet {
            self.redraw()
        }
    }
    
    private var _height: CGFloat = 0
    public var height: CGFloat {
        get {
            return self._height
        }
    }
    
    /// Always the last button is added.
    private var lastTagButton: TagButton?
    
    // MARK: Initializers
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        
        let currentWidth = self.frame.width
        if self.width == 0 {
            self.width = currentWidth
        }
        
        DispatchQueue.main.async {
            if self.width == 0 || (self.width != 0 && self.frame.width != currentWidth) {
                self.width = self.frame.width
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        if self.width == 0 {
            self.width = frame.width
        }
    }
    
    public init(width: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        
        self.clipsToBounds = true
        
        if self.width == 0 {
            self.width = width
        }
    }
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.clipsToBounds = true
        
        let currentWidth = self.frame.width
        if self.width == 0 {
            self.width = currentWidth
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layoutIfNeeded()
            if self.width == 0 || (self.width != 0 && self.frame.width != currentWidth) {
                self.width = self.frame.width
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: self.width, height: 0)
    }
    
    
    // MARK: Properties
    
    
    /// LineBreakMode of button
    public var lineBreakMode: NSLineBreakMode = TagDefaultOption.lineBreakMode
    
    /**
     The tag is truncated to a ,
     */
    @IBInspectable
    public var tags: String = "" {
        didSet {
            for element in self._tagArray {
                element.removeConstraint()
                element.removeFromSuperview()
            }
            self._tagArray.removeAll()
            self.append(contentsOf: self.tags.components(separatedBy: ",").filter({ $0 != "" }))
        }
    }
    
    
    /// Left and right paddings of the button
    @IBInspectable
    public var paddingHorizontal: CGFloat = TagDefaultOption.paddingHorizontal {
        didSet {
            self.redraw()
        }
    }
    
    /// Top and bottom paddings of the button
    @IBInspectable
    public var paddingVertical: CGFloat = TagDefaultOption.paddingVertical {
        didSet {
            self.redraw()
        }
    }
    
    /// Left and right margins of the button
    @IBInspectable
    public var marginHorizontal: CGFloat = TagDefaultOption.marginHorizontal {
        didSet {
            self.redraw()
        }
    }
    
    /// Top and Bottom margins of the button
    @IBInspectable
    public var marginVertical: CGFloat = TagDefaultOption.marginVertical {
        didSet {
            self.redraw()
        }
    }
    
    
    /// The rounded corner of the button
    @IBInspectable
    public var tagLayerRadius: CGFloat = TagDefaultOption.tagLayerRadius {
        didSet {
            self.redraw()
        }
    }
    
    /// The line size of the button
    @IBInspectable
    public var tagLayerWidth: CGFloat = TagDefaultOption.tagLayerWidth {
        didSet {
            self.redraw()
        }
    }
    
    /// Color of the button's line
    @IBInspectable
    public var tagLayerColor: UIColor = TagDefaultOption.tagLayerColor {
        didSet {
            self.redraw()
        }
    }
    
    
    /// The color of the button's text
    @IBInspectable
    public var tagTitleColor: UIColor = TagDefaultOption.tagTitleColor {
        didSet {
            self.redraw()
        }
    }
    
    /// Background color of button
    @IBInspectable
    public var tagBackgroundColor: UIColor = TagDefaultOption.tagBackgroundColor {
        didSet {
            self.redraw()
        }
    }
    
    /// Font of button
    @IBInspectable
    public var tagFont: UIFont = TagDefaultOption.tagFont {
        didSet {
            self.redraw()
        }
    }
    
    /// Always the last button is added.
    @IBInspectable
    public var lastTag: String? = nil {
        didSet {
            self.lastTagButton?.removeConstraint()
            self.lastTagButton?.removeFromSuperview()
            self.lastTagButton = nil
            if let text = self.lastTag {
                let button = TagButton(type: .system)
                button.delegate = self
                button.type = .last
                button.setEntity(title: text)
                self.lastTagButton = button
                self.redraw()
            } else {
                self.redraw()
            }
        }
    }
    
    /// The color of the lastTagButton text
    @IBInspectable
    public var lastTagTitleColor: UIColor = TagDefaultOption.lastTagTitleColor {
        didSet {
            if self.lastTag != nil { self.redraw() }
        }
    }
    
    /// Color of the lastTagButton line
    @IBInspectable
    public var lastTagLayerColor: UIColor = TagDefaultOption.lastTagLayerColor {
        didSet {
            if self.lastTag != nil { self.redraw() }
        }
    }
    
    /// Background color of lastTagButton
    @IBInspectable
    public var lastTagBackgroundColor: UIColor = TagDefaultOption.lastTagBackgroundColor {
        didSet {
            self.redraw()
        }
    }
    
    
    // MARK: func
    
    /// append TagButton
    @discardableResult
    public func append(_ button: TagButton) -> TagButton {
        button.delegate = self
        button.type = .custom
        button.setEntity()
        button.setEntity(paddingHorizontal: self.paddingHorizontal, paddingVertical: self.paddingVertical)
        self._tagArray.append(button)
        self.redraw()
        return button
    }
    
    /// append TagButtons
    public func append(contentsOf: [TagButton]) {
        for button in contentsOf {
            button.delegate = self
            button.type = .custom
            button.setEntity()
            button.setEntity(paddingHorizontal: self.paddingHorizontal, paddingVertical: self.paddingVertical)
            self._tagArray.append(button)
        }
        self.redraw()
    }
    
    /// append a String as a TagButton
    @discardableResult
    public func append(_ text: String) -> TagButton {
        let button = TagButton(type: .system)
        button.delegate = self
        
        button.setEntity(title: text)
        self._tagArray.append(button)
        self.redraw()
        return button
    }
    
    /// append a Strings as a TagButtons
    public func append(contentsOf: [String]) {
        for text in contentsOf {
            let button = TagButton(type: .system)
            button.delegate = self
            button.setEntity(title: text)
            self._tagArray.append(button)
        }
        self.redraw()
    }
    
    /// set TagButtons
    public func set(contentsOf: [TagButton]) {
        self.removeAll()
        self.append(contentsOf: contentsOf)
    }
    
    /// set a Strings as a TagButtons
    public func set(contentsOf: [String]) {
        self.removeAll()
        self.append(contentsOf: contentsOf)
    }
    
    /// Change the TagButton at index
    @discardableResult
    public func update(_ button: TagButton, at index: Int) -> TagButton? {
        if index < 0 { return nil }
        if self._tagArray.count > index {
            button.delegate = self
            button.type = .custom
            button.setEntity()
            button.setEntity(paddingHorizontal: self.paddingHorizontal, paddingVertical: self.paddingVertical)
            self._tagArray[index].isHidden = true
            self._tagArray[index].removeConstraint()
            self._tagArray[index].removeFromSuperview()
            self._tagArray[index] = button
            self.redraw()
            return button
        }
        return nil
    }
    
    /// Change the String at index
    @discardableResult
    public func update(_ text: String, at index: Int) -> TagButton? {
        if index < 0 { return nil }
        if self._tagArray.count > index {
            let button = TagButton(type: .system)
            button.delegate = self
            button.setEntity(title: text)
            self._tagArray[index].isHidden = true
            self._tagArray[index].removeConstraint()
            self._tagArray[index].removeFromSuperview()
            self._tagArray[index] = button
            self.redraw()
            return button
        }
        return nil
    }
    
    /// Insert the TagButton at index
    @discardableResult
    public func insert(_ button: TagButton, at index: Int) -> TagButton {
        if self._tagArray.count > index {
            button.delegate = self
            button.type = .custom
            button.setEntity()
            button.setEntity(paddingHorizontal: self.paddingHorizontal, paddingVertical: self.paddingVertical)
            self._tagArray.insert(button, at: index < 0 ? 0 : index)
            self.redraw()
            return button
        } else {
            return self.append(button)
        }
    }
    
    /// Insert the String at index
    @discardableResult
    public func insert(_ text: String, at index: Int) -> TagButton {
        if self._tagArray.count > index {
            let button = TagButton(type: .system)
            button.delegate = self
            button.setEntity(title: text)
            self._tagArray.insert(button, at: index < 0 ? 0 : index)
            self.redraw()
            return button
        } else {
            return append(text)
        }
    }
    
    /// Remove at index
    @discardableResult
    public func remove(_ index: Int) -> TagButton? {
        if index < 0 { return nil }
        if self._tagArray.count > index {
            let item = self._tagArray.remove(at: index)
            item.isHidden = true
            item.removeConstraint()
            item.removeFromSuperview()
            self.redraw()
            return item
        }
        return nil
    }
    
    
    /// Remove TagButton
    @discardableResult
    public func remove(_ button: TagButton) -> TagButton? {
        for (index, element) in self._tagArray.enumerated() {
            if element == button {
                let item = self._tagArray.remove(at: index)
                item.isHidden = true
                item.removeConstraint()
                item.removeFromSuperview()
                self.redraw()
                return item
            }
        }
        return nil
    }
    
    /// Remove Tag
    public func removeTags() {
        self._tagArray.forEach { (element) in
            element.isHidden = true
            element.removeConstraint()
            element.removeFromSuperview()
        }
        self.lastTagButton?.removeConstraint()
        self.lastTagButton?.removeFromSuperview()
        self.removeConstraints(self.constraints)
        self._tagArray.removeAll()
        self.redraw()
    }
    
    /// RemoveAll
    public func removeAll() {
        self.removeTags()
        self.removeLastTag()
    }
    
    
    /// Remove Last Tag
    public func removeLastTag() {
        self.lastTag = nil
        self.redraw()
    }
    
    
    /// Last Custom Button
    public func lastTagButton(_ button: TagButton) {
        self.lastTagButton?.removeConstraint()
        self.lastTagButton?.removeFromSuperview()
        self.lastTagButton = nil
        button.delegate = self
        button.type = .lastCustom
        self.lastTagButton = button
        self.redraw()
    }
    
    /// RemoveAll Constraint
    private func removeAllConstraint() {
        self._tagArray.forEach { (element) in
            element.removeConstraint()
            element.removeFromSuperview()
        }
        self.lastTagButton?.removeConstraint()
        self.lastTagButton?.removeFromSuperview()
        self.removeConstraints(self.constraints)
    }
    
    
    
    // MARK: - View updates
    
    
    /// It is called when you add, delete or modify a button.
    public func redraw() {
        var topItem: UIView?
        var leftItem: UIView?
        var buttonsWidth: CGFloat = 0
        
        self.removeAllConstraint()
        
        if (self._tagArray.isEmpty && self.lastTag == nil && self.lastTagButton == nil) || self.width < (self.marginHorizontal + self.paddingHorizontal) + 5 {
            self._height = 0
            self.delegate?.tagsChangeHeight(self, height: 0)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
            heightConstraint.priority = UILayoutPriority(950)
            self.addConstraint(heightConstraint)
            return
        }
        
        var tagArray = self._tagArray
        if let tagButton = self.lastTagButton {
            tagArray.append(tagButton)
        }
        
        self._height = 0
        if !tagArray.isEmpty {
            self._height += self.marginVertical + tagArray[0].size.height + self.marginVertical
        }
        
        
        for (index, element) in tagArray.enumerated() {
            self.addSubview(element)
            element.index = index
            if element.type == .default || element.type == .last {
                element.setEntityOptions(ButtonOptions(
                    paddingHorizontal: self.paddingHorizontal,
                    paddingVertical: self.paddingVertical,
                    layerColor: element.type == .default ? self.tagLayerColor : self.lastTagLayerColor,
                    layerRadius: self.tagLayerRadius,
                    layerWidth: self.tagLayerWidth,
                    tagTitleColor: element.type == .default ? self.tagTitleColor : self.lastTagTitleColor,
                    tagFont: self.tagFont,
                    tagBackgroundColor: element.type == .default ? self.tagBackgroundColor : self.lastTagBackgroundColor,
                    lineBreakMode: self.lineBreakMode
                ))
            } else {
                element.setEntity(paddingHorizontal: self.paddingHorizontal, paddingVertical: self.paddingVertical)
            }
            element.addConstraint()
            
            var width = ceil(element.size.width) +
                self.marginHorizontal +
                (buttonsWidth == 0 ? self.marginHorizontal : 0)
            
            /// Prev Element Trailing, Next Line
            if !( buttonsWidth == 0 || (floor(self.width) - buttonsWidth - width - 10 > 0) ) {
                self.addConstraint(tagArray[index-1].trailingConstraint(
                    self,
                    constant: self.marginHorizontal
                ))
                width = ceil(element.size.width) + self.marginHorizontal + self.marginHorizontal
                buttonsWidth = 0
                topItem = tagArray[index-1]
                leftItem = nil
                self._height += element.size.height + self.marginVertical
            }
            
            
            
            self.addConstraint(element.leadingConstraint (
                leftItem ?? self,
                attribute: leftItem == nil ? .leading : .trailing,
                constant: self.marginHorizontal
            ))
            self.addConstraint(element.topConstraint (
                topItem ?? self,
                attribute: topItem == nil ? .top : .bottom,
                constant: self.marginVertical
            ))
            if element == tagArray[tagArray.count-1] {
                self.addConstraint(element.bottomConstraint(
                    self,
                    constant: self.marginVertical
                ))
                self.addConstraint(element.trailingConstraint(
                    self,
                    constant: self.marginHorizontal
                ))
            }
            
            leftItem = element
            buttonsWidth += width
        }
        
        self.delegate?.tagsChangeHeight(self, height: height)
    }
    
    
}

// MARK: TagButtonDelegate
extension TagsView: TagButtonDelegate {
    /// button touchUpInside Action
    func tagButtonAction(_ tagButton: TagButton, type: TagButtonType) {
        if type == .last || type == .lastCustom {
            self.delegate?.tagsLastTagAction(self, tagButton: tagButton)
        }else{
            self.delegate?.tagsTouchAction(self, tagButton: tagButton)
        }
    }
}
