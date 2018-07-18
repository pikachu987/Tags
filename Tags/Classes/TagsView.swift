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
    public func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) { }
    public func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) { }
    public func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) { }
}

public class TagDefaultOption {
    public static var paddingLeftRight: CGFloat = 6
    public static let paddingTopBottom: CGFloat = 4
    public static var marginLeftRight: CGFloat = 6
    public static var marginTopBottom: CGFloat = 4
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
public class TagsView: UIView{
    public weak var delegate: TagsDelegate?
    
    
    
    
    // MARK: var
    private var _tagArray = [TagButton]()
    
    
    public var tagArray: [TagButton]{
        get{
            return self._tagArray.map({ $0 })
        }
    }
    
    public var tagTextArray: [String]{
        get{
            return self._tagArray.compactMap({ $0.currentTitle })
        }
    }
    
    public var width: CGFloat = UIScreen.main.bounds.width
    private var _height: CGFloat = 0
    public var height: CGFloat{
        get{
            return self._height
        }
    }
    
    /// Always the last button is added.
    private var lastTagButton: TagButton?
    
    
    // MARK: Initializers
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.width = self.frame.width
        self.clipsToBounds = true
        
        self.redraw()
    }
    
    
    public override var intrinsicContentSize: CGSize{
        return CGSize(width: self.width, height: 0)
    }
    
    
    
    
    
    
    // MARK: Properties
    
    
    
    /// LineBreakMode of button
    public var lineBreakMode: NSLineBreakMode = TagDefaultOption.lineBreakMode
    
    /**
     The tag is truncated to a ,
     */
    @IBInspectable
    public var tags: String = ""{
        didSet{
            self._tagArray.removeAll()
            self.append(contentsOf: self.tags.components(separatedBy: ",").filter({ $0 != "" }))
        }
    }
    
    
    /// Left and right paddings of the button
    @IBInspectable
    public var paddingLeftRight: CGFloat = TagDefaultOption.paddingLeftRight{
        didSet{
            self.redraw()
        }
    }
    
    /// Top and bottom paddings of the button
    @IBInspectable
    public var paddingTopBottom: CGFloat = TagDefaultOption.paddingTopBottom{
        didSet{
            self.redraw()
        }
    }
    
    
    /// Left and right margins of the button
    @IBInspectable
    public var marginLeftRight: CGFloat = TagDefaultOption.marginLeftRight{
        didSet{
            self.redraw()
        }
    }
    
    /// Top and Bottom margins of the button
    @IBInspectable
    public var marginTopBottom: CGFloat = TagDefaultOption.marginTopBottom{
        didSet{
            self.redraw()
        }
    }
    
    
    /// The rounded corner of the button
    @IBInspectable
    public var tagLayerRadius: CGFloat = TagDefaultOption.tagLayerRadius{
        didSet{
            self.redraw()
        }
    }
    
    /// The line size of the button
    @IBInspectable
    public var tagLayerWidth: CGFloat = TagDefaultOption.tagLayerWidth{
        didSet{
            self.redraw()
        }
    }
    
    /// Color of the button's line
    @IBInspectable
    public var tagLayerColor: UIColor = TagDefaultOption.tagLayerColor{
        didSet{
            self.redraw()
        }
    }
    
    
    /// The color of the button's text
    @IBInspectable
    public var tagTitleColor: UIColor = TagDefaultOption.tagTitleColor{
        didSet{
            self.redraw()
        }
    }
    
    /// Background color of button
    @IBInspectable
    public var tagBackgroundColor: UIColor = TagDefaultOption.tagBackgroundColor{
        didSet{
            self.redraw()
        }
    }
    
    /// Font of button
    @IBInspectable
    public var tagFont: UIFont = TagDefaultOption.tagFont{
        didSet{
            self.redraw()
        }
    }
    
    /// Always the last button is added.
    @IBInspectable
    public var lastTag: String? = nil{
        didSet{
            if let text = self.lastTag{
                let button = TagButton(type: .system)
                button.delegate = self
                button.type = .last
                button.setEntity(title: text)
                self.lastTagButton = button
                self.redraw()
            }else{
                self.lastTagButton = nil
                self.redraw()
            }
        }
    }
    
    /// The color of the lastTagButton text
    @IBInspectable
    public var lastTagTitleColor: UIColor = TagDefaultOption.lastTagTitleColor{
        didSet{
            if self.lastTag != nil{ self.redraw() }
        }
    }
    
    /// Color of the lastTagButton line
    @IBInspectable
    public var lastTagLayerColor: UIColor = TagDefaultOption.lastTagLayerColor{
        didSet{
            if self.lastTag != nil{ self.redraw() }
        }
    }
    
    /// Background color of lastTagButton
    @IBInspectable
    public var lastTagBackgroundColor: UIColor = TagDefaultOption.lastTagBackgroundColor{
        didSet{
            self.redraw()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: func
    
    
    /// append TagButton
    @discardableResult
    public func append(_ button: TagButton) -> TagButton{
        button.delegate = self
        button.type = .custom
        button.setEntity()
        button.setEntity(paddingLeftRight: self.paddingLeftRight, paddingTopBottom: self.paddingTopBottom)
        self._tagArray.append(button)
        self.redraw()
        return button
    }
    
    /// append TagButtons
    public func append(contentsOf: [TagButton]){
        for button in contentsOf{
            button.delegate = self
            button.type = .custom
            button.setEntity()
            button.setEntity(paddingLeftRight: self.paddingLeftRight, paddingTopBottom: self.paddingTopBottom)
            self._tagArray.append(button)
        }
        self.redraw()
    }
    
    /// append a String as a TagButton
    @discardableResult
    public func append(_ text: String) -> TagButton{
        let button = TagButton(type: .system)
        button.delegate = self
        
        button.setEntity(title: text)
        self._tagArray.append(button)
        self.redraw()
        return button
    }
    
    /// append a Strings as a TagButtons
    public func append(contentsOf: [String]){
        for text in contentsOf{
            let button = TagButton(type: .system)
            button.delegate = self
            button.setEntity(title: text)
            self._tagArray.append(button)
        }
        self.redraw()
    }
    
    
    
    
    /// Change the TagButton at index
    @discardableResult
    public func update(_ button: TagButton, at index: Int) -> TagButton?{
        if index < 0 { return nil }
        if self._tagArray.count > index{
            button.delegate = self
            button.type = .custom
            button.setEntity()
            button.setEntity(paddingLeftRight: self.paddingLeftRight, paddingTopBottom: self.paddingTopBottom)
            self._tagArray[index] = button
            self.redraw()
            return button
        }
        return nil
    }
    
    /// Change the String at index
    @discardableResult
    public func update(_ text: String, at index: Int) -> TagButton?{
        if index < 0 { return nil }
        if self._tagArray.count > index{
            let button = TagButton(type: .system)
            button.delegate = self
            button.setEntity(title: text)
            self._tagArray[index] = button
            self.redraw()
            return button
        }
        return nil
    }
    
    /// Insert the TagButton at index
    @discardableResult
    public func insert(_ button: TagButton, at index: Int) -> TagButton{
        if self._tagArray.count > index{
            button.delegate = self
            button.type = .custom
            button.setEntity()
            button.setEntity(paddingLeftRight: self.paddingLeftRight, paddingTopBottom: self.paddingTopBottom)
            self._tagArray.insert(button, at: index < 0 ? 0 : index)
            self.redraw()
            return button
        }else{
            return self.append(button)
        }
    }
    
    /// Insert the String at index
    @discardableResult
    public func insert(_ text: String, at index: Int) -> TagButton{
        if self._tagArray.count > index{
            let button = TagButton(type: .system)
            button.delegate = self
            button.setEntity(title: text)
            self._tagArray.insert(button, at: index < 0 ? 0 : index)
            self.redraw()
            return button
        }else{
            return append(text)
        }
    }
    
    /// Remove at index
    @discardableResult
    public func remove(_ index: Int) -> TagButton?{
        if index < 0 { return nil }
        if self._tagArray.count > index{
            let item = self._tagArray.remove(at: index)
            self.redraw()
            return item
        }
        return nil
    }
    
    
    /// Remove TagButton
    @discardableResult
    public func remove(_ button: TagButton) -> TagButton?{
        for (index, element) in self._tagArray.enumerated(){
            if element == button{
                let item = self._tagArray.remove(at: index)
                self.redraw()
                return item
            }
        }
        return nil
    }
    
    
    
    /// RemoveAll
    public func removeAll(){
        for element in self._tagArray{
            element.removeConstraint()
            element.removeFromSuperview()
        }
        self.lastTagButton?.removeConstraint()
        self.lastTagButton?.removeFromSuperview()
        self.removeConstraints(self.constraints)
        self._tagArray.removeAll()
        self.redraw()
    }
    
    
    /// Last Custom Button
    public func lastTagButton(_ button: TagButton){
        button.delegate = self
        button.type = .lastCustom
        self.lastTagButton = button
        self.redraw()
    }
    
    
    
    /// RemoveAll Constraint
    private func removeAllConstraint(){
        for element in self._tagArray{
            element.removeConstraint()
            element.removeFromSuperview()
        }
        self.lastTagButton?.removeConstraint()
        self.lastTagButton?.removeFromSuperview()
        self.removeConstraints(self.constraints)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - View updates
    
    
    /// It is called when you add, delete or modify a button.
    public func redraw(){
        var topItem: UIView?
        var leftItem: UIView?
        var buttonsWidth: CGFloat = 0
        
        self.removeAllConstraint()
        
        if self._tagArray.isEmpty && self.lastTag == nil{
            self._height = 0
            self.delegate?.tagsChangeHeight(self, height: 0)
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0))
            return
        }
        
        var tagArray = self._tagArray
        if let tagButton = self.lastTagButton{
            tagArray.append(tagButton)
        }
        
        self._height = 0
        if !tagArray.isEmpty{
            self._height += self.marginTopBottom + tagArray[0].size.height + self.marginTopBottom
        }
        
        
        for (index, element) in tagArray.enumerated(){
            self.addSubview(element)
            element.index = index
            if element.type == .default || element.type == .last{
                element.setEntityOptions(options: ButtonOptions(
                    paddingLeftRight: self.paddingLeftRight,
                    paddingTopBottom: self.paddingTopBottom,
                    layerColor: element.type == .default ? self.tagLayerColor : self.lastTagLayerColor,
                    layerRadius: self.tagLayerRadius,
                    layerWidth: self.tagLayerWidth,
                    tagTitleColor: element.type == .default ? self.tagTitleColor : self.lastTagTitleColor,
                    tagFont: self.tagFont,
                    tagBackgroundColor: element.type == .default ? self.tagBackgroundColor : self.lastTagBackgroundColor,
                    lineBreakMode: self.lineBreakMode
                ))
            }else{
                element.setEntity(paddingLeftRight: self.paddingLeftRight, paddingTopBottom: self.paddingTopBottom)
            }
            element.addConstraint()
            
            var width = ceil(element.size.width) +
                self.marginLeftRight +
                (buttonsWidth == 0 ? self.marginLeftRight : 0)
            
            /// Prev Element Trailing, Next Line
            if !( buttonsWidth == 0 || (floor(self.width) - buttonsWidth - width > 0) ){
                self.addConstraint(tagArray[index-1].trailingConstraint(
                    self,
                    constant: self.marginLeftRight
                ))
                width = ceil(element.size.width) + self.marginLeftRight + self.marginLeftRight
                buttonsWidth = 0
                topItem = tagArray[index-1]
                leftItem = nil
                self._height += element.size.height + self.marginTopBottom
            }
            
            
            
            self.addConstraint(element.leadingConstraint(
                leftItem ?? self,
                attribute: leftItem == nil ? .leading : .trailing,
                constant: self.marginLeftRight
            ))
            self.addConstraint(element.topConstraint(
                topItem ?? self,
                attribute: topItem == nil ? .top : .bottom,
                constant: self.marginTopBottom
            ))
            if element == tagArray[tagArray.count-1]{
                self.addConstraint(element.bottomConstraint(
                    self,
                    constant: self.marginTopBottom
                ))
                self.addConstraint(element.trailingConstraint(
                    self,
                    constant: self.marginLeftRight
                ))
            }
            
            leftItem = element
            buttonsWidth += width
        }
        
        self.delegate?.tagsChangeHeight(self, height: height)
    }
    
    
    
    
    
    
    
}


extension TagsView: TagButtonDelegate{
    // MARK: TagButtonDelegate
    
    /// button touchUpInside Action
    func tagButtonAction(_ tagButton: TagButton, type: TagButtonType) {
        if type == .last || type == .lastCustom{
            self.delegate?.tagsLastTagAction(self, tagButton: tagButton)
        }else{
            self.delegate?.tagsTouchAction(self, tagButton: tagButton)
        }
    }
}
