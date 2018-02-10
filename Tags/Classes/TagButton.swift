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


/// Button option
public struct ButtonOptions{
    public var paddingLeftRight: CGFloat = TagDefaultOption.paddingLeftRight
    public var paddingTopBottom: CGFloat = TagDefaultOption.paddingTopBottom
    public var layerColor: UIColor
    public var layerRadius: CGFloat
    public var layerWidth: CGFloat
    public var tagTitleColor: UIColor
    public var tagFont: UIFont
    public var tagBackgroundColor: UIColor
    public var lineBreakMode: NSLineBreakMode
    
    init(
        paddingLeftRight: CGFloat = TagDefaultOption.paddingLeftRight,
        paddingTopBottom: CGFloat = TagDefaultOption.paddingTopBottom,
        layerColor: UIColor = TagDefaultOption.tagLayerColor,
        layerRadius: CGFloat = TagDefaultOption.tagLayerRadius,
        layerWidth: CGFloat = TagDefaultOption.tagLayerWidth,
        tagTitleColor: UIColor = TagDefaultOption.tagTitleColor,
        tagFont: UIFont = TagDefaultOption.tagFont,
        tagBackgroundColor: UIColor = TagDefaultOption.tagBackgroundColor,
        lineBreakMode: NSLineBreakMode = TagDefaultOption.lineBreakMode) {
        self.paddingLeftRight = paddingLeftRight
        self.paddingTopBottom = paddingTopBottom
        self.layerColor = layerColor
        self.layerRadius = layerRadius
        self.layerWidth = layerWidth
        self.tagTitleColor = tagTitleColor
        self.tagFont = tagFont
        self.tagBackgroundColor = tagBackgroundColor
        self.lineBreakMode = lineBreakMode
    }
    
    public init(
        layerColor: UIColor = TagDefaultOption.tagLayerColor,
        layerRadius: CGFloat = TagDefaultOption.tagLayerRadius,
        layerWidth: CGFloat = TagDefaultOption.tagLayerWidth,
        tagTitleColor: UIColor = TagDefaultOption.tagTitleColor,
        tagFont: UIFont = TagDefaultOption.tagFont,
        tagBackgroundColor: UIColor = TagDefaultOption.tagBackgroundColor,
        lineBreakMode: NSLineBreakMode = TagDefaultOption.lineBreakMode) {
        self.layerColor = layerColor
        self.layerRadius = layerRadius
        self.layerWidth = layerWidth
        self.tagTitleColor = tagTitleColor
        self.tagFont = tagFont
        self.tagBackgroundColor = tagBackgroundColor
        self.lineBreakMode = lineBreakMode
    }
}



protocol TagButtonDelegate: class {
    /// When you touch the button, the function is called.
    func tagButtonAction(_ tagButton: TagButton, type: TagButtonType)
}

/// Button Type
enum TagButtonType{
    case custom, `default`, last, lastCustom
}

public class TagButton: UIButton{
    // MARK: var
    
    weak var delegate: TagButtonDelegate?
    public var index: Int = 0
    
    var type: TagButtonType = .default
    
    /// button Size
    var size: CGSize{
        var size = self.titleLabel?.attributedText?.size() ?? .zero
        size.width = ceil(size.width)
        size.height = ceil(size.height)
        size.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right
        size.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom
        size.width += 4
        size.height += 4
        return size
    }
    
    //MARK: func
    
    /// Set an option.
    public func setEntity(_ options: ButtonOptions){
        self.setEntity()
        self.setEntityOptions(options: options)
    }
    
    /// module private set options
    func setEntityOptions(options: ButtonOptions){
        self.contentEdgeInsets = UIEdgeInsetsMake(options.paddingTopBottom, options.paddingLeftRight, options.paddingTopBottom, options.paddingLeftRight)
        self.layer.borderColor = options.layerColor.cgColor
        self.layer.borderWidth = options.layerWidth
        self.layer.cornerRadius = options.layerRadius
        self.setTitleColor(options.tagTitleColor, for: .normal)
        self.titleLabel?.font = options.tagFont
        self.backgroundColor = options.tagBackgroundColor
        self.titleLabel?.lineBreakMode = options.lineBreakMode
    }
    
    
    /// padding set
    func setEntity(paddingLeftRight: CGFloat, paddingTopBottom: CGFloat){
        self.contentEdgeInsets = UIEdgeInsetsMake(paddingTopBottom, paddingLeftRight, paddingTopBottom, paddingLeftRight)
    }
    
    
    /// set title.
    func setEntity(title: String){
        self.setTitle(title, for: .normal)
        self.setEntity()
    }
    
    /// set default
    func setEntity(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()
        
        self.removeTarget(self, action: #selector(self.touchAction(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.touchAction(_:)), for: .touchUpInside)
    }
    
    
    /// Add Constraint
    func addConstraint(){
        self.removeConstraint()
        let widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: self.size.width)
        let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: self.size.height)
        widthConstraint.priority = UILayoutPriority(900)
        heightConstraint.priority = UILayoutPriority(900)
        self.addConstraints([widthConstraint, heightConstraint])
    }
    
    /// Remove Constraint
    func removeConstraint(){
        self.removeConstraints(self.constraints)
    }
    
    
    // MARK: action
    @objc private func touchAction(_ sender: UIButton){
        self.delegate?.tagButtonAction(self, type: self.type)
    }
}
