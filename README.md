# Tags

[![Version](https://img.shields.io/cocoapods/v/Tags.svg?style=flat)](http://cocoapods.org/pods/Tags)
[![License](https://img.shields.io/cocoapods/l/Tags.svg?style=flat)](http://cocoapods.org/pods/Tags)
[![Platform](https://img.shields.io/cocoapods/p/Tags.svg?style=flat)](http://cocoapods.org/pods/Tags)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

## Introduce

dynamically add, modify, and delete tags, and you can easily change the margins, colors, and fonts of your tags.
Tags are not broken because they are linked with Auto Layout.
Each time the height of the tag changes, you can bring the height to the delegate


![demo](./img/tag1.gif)
![demo2](./img/tag2.gif)
![demo2](./img/tag3.gif)
![image](./img/ex.png)

## Requirements

`Tags` written in Swift 5.0. Compatible with iOS 8.0+

## Installation


### Versioning notes

Version 0.3.0 introduces Swift 5.0 support

Version 0.2.4 introduces Swift 4.2 support

Version 0.1.8 introduces Swift 4.0 support

### Cocoapods

Tags is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Tags'

# For Swift 4.2 (no longer maintained), use:
# pod 'Tags', '~> 0.2.4'

# For Swift 4.0 (no longer maintained), use:
# pod 'Tags', '~> 0.1.8'
```

### Swift Package Manager

To integrate `Tags` via [SPM](https://swift.org/package-manager/) into your Xcode 11 project specify it in Project > Swift Packages:
```
https://github.com/pikachu987/Tags
```

## Usage


### Xib or Storyboard file

setting

![image](./img/example1.png)

![image](./img/example2.png)

view

![image](./img/example3.png) 
![image](./img/example4.png)

done!

<br><br><br>

### Code editor

```swift
import Tags
```

```swift
let tagView = TagsView()
self.view.addSubview(tagView)
```
AutoLayout Example

```swift
tagView.translatesAutoresizingMaskIntoConstraints = false
self.view.addConstraint(NSLayoutConstraint(
    item: self.view,
    attribute: .leading,
    relatedBy: .equal,
    toItem: tagView,
    attribute: .leading,
    multiplier: 1,
    constant: 0)
)
self.view.addConstraint(NSLayoutConstraint(
    item: self.view,
    attribute: .trailing,
    relatedBy: .equal,
    toItem: tagView,
    attribute: .trailing,
    multiplier: 1,
    constant: 0)
)
self.view.addConstraint(NSLayoutConstraint(
    item: self.view,
    attribute: .top,
    relatedBy: .equal,
    toItem: tagView,
    attribute: .top,
    multiplier: 1,
    constant: 0)
)
```

done!

<br><br><br>



### Property

tags

```swift
//Returned as an array of strings
tagsView.tagTextArray//get-only

//Returned as an array of TagButton
tagsView.tagArray//get-only
```

height

```swift
tagsView.height//get-only
```

padding & margin

![image](./img/margin_padding.png)

```swift
tagsView.paddingHorizontal = 6
tagsView.paddingVertical = 4
tagsView.marginHorizontal = 6
tagsView.marginVertical = 4
```


tag

```swift
// layer radius
tagsView.tagLayerRadius = 6
// layer width
tagsView.tagLayerWidth = 1
// layer color
tagsView.tagLayerColor = .black
// text color
tagsView.tagTitleColor = .black
// background color
tagsView.tagBackgroundColor = .white
// font
tagsView.tagFont = .systemFont(ofSize: 15)
// text longer ...
tagsView.lineBreakMode = .byTruncatingMiddle
// tag add
tagsView.tags = "Hello,Swift"
```

lastTag

```swift
// lastTag title
tagsView.lastTag = "+"
// lastTag titleColor
tagsView.lastTagTitleColor = .black
// lastTag layer Color
tagsView.lastTagLayerColor = .black
// lastTag background Color
tagsView.lastTagBackgroundColor = .white
```

<br><br>

### Method

append

```swift
tagsView.append("Hello")
tagsView.append(contentsOf: ["Hello", "World"])
tagsView.append(TagButton())
tagsView.append(contentsOf: [TagButton(), TagButton()])
```

set

```swift
tagsView.set(contentsOf: ["Hello", "World"])
tagsView.set(contentsOf: [TagButton(), TagButton()])
```

update

```swift
tagsView.update("Hi", at: 0)
tagsView.update(TagButton(), at: 0)
```

insert

```swift
tagsView.insert("World", at: 0)
tagsView.insert(TagButton(), at: 0)
```

remove

```swift
tagsView.remove(0)
tagsView.remove(TagButton())
tagsView.removeTags()
tagsView.removeLastTag()
tagsView.removeAll()
```

lastTag

```swift
// lastTag Button
tagsView.lastTagButton(TagButton())
```

redraw

```swift
// ReDraw
tagsView.redraw()
```

<br><br>

### Delegate

```swift
class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tagsView = TagsView()
        tagsView.delegate = self
    }
}

extension ViewController: TagsDelegate{

    // Tag Touch Action
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
    
    }
    
    // Last Tag Touch Action
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
    
    }
    
    // TagsView Change Height
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
    
    }
}

```

<br><br>

### Customize

TagButton Customize

```swift
let button = TagButton()
button.setTitle("Tag", for: .normal)
let options = ButtonOptions(
    layerColor: UIColor.black, // layer Color
    layerRadius: 6.0, // layer Radius
    layerWidth: 1.0, // layer Width
    tagTitleColor: UIColor.black, // title Color
    tagFont: UIFont.systemFont(ofSize: 15), // Font
    tagBackgroundColor: UIColor.white, // Background Color
    lineBreakMode: NSLineBreakMode.byTruncatingMiddle //break Mode
)
button.setEntity(options)
tagsView.append(button)
```

LastTagButton Customize

```swift
let button = TagButton()
button.setTitle("Tag", for: .normal)
let options = ButtonOptions(
    layerColor: UIColor.black, // layer Color
    layerRadius: 6.0, // layer Radius
    layerWidth: 1.0, // layer Width
    tagTitleColor: UIColor.black, // title Color
    tagFont: UIFont.systemFont(ofSize: 15), // Font
    tagBackgroundColor: UIColor.white, // Background Color
    lineBreakMode: NSLineBreakMode.byTruncatingMiddle //break Mode
)
button.setEntity(options)
tagsView.lastTagButton(TagButton())
```

## Custom Tag Layout

```swift
self.tagsView.tagLayerColor = .clear
self.tagsView.marginHorizontal = 0
self.tagsView.paddingHorizontal = 0
self.tagsView.marginVertical = 0
self.tagsView.paddingVertical = 1

// id or nickname

let idButton = TagButton()
idButton.setTitle("pikachu987", for: .normal)
let options = ButtonOptions(
layerColor: UIColor.clear,
tagTitleColor: UIColor.black,
tagFont: UIFont.boldSystemFont(ofSize: 15),
tagBackgroundColor: UIColor.clear)
idButton.setEntity(options)

self.tagsView.append(idButton)


// array data

let array = ["Hello Instagram Tag Example", "@Lorem", "ipsum", "@dolor", "sit", "@er", "elit", "@lamet, consectetaur", "@cillium", "@adipisicing", "@pecu, sed", "@do", "@eiusmod", "tempor", "@incididunt", "ut", "@labore", "@et", "@dolore", "@magna", "@aliqua.", "Ut", "@enim", "@ad", "@minim", "@veniam", "@quis", "@nostrud", "@exercitation", "@ullamco", "@laboris", "@nisi", "@ut", "@aliquip", "@ex", "@ea", "@commodo", "@consequat.", "@Duis", "@aute", "@irure", "@dolor", "@in", "@reprehenderit", "@in", "@voluptate", "@velit", "@esse", "@cillum", "@dolore", "@eu", "@fugiat", "@nulla", "@pariatur.", "@Excepteur", "@sint", "@occaecat", "@cupidatat", "@non", "@proident,", "@sunt", "@in", "@culpa", "@qui", "@officia", "@deserunt", "@mollit", "@anim", "@id", "@est", "@laborum.", "@Nam", "@liber", "@te", "@conscient", "@to", "@factor", "@tum", "@poen", "@legum", "@odioque", "@civiuda."]

let tags = array.enumerated().map({ (tag) -> TagButton in
    let titleColor = tag.element.hasPrefix("@") ? UIColor(red: 33/255, green: 100/255, blue: 255/255, alpha: 1) : .black
    let tagButton = TagButton()
    tagButton.setTitle(tag.element, for: .normal)
    let options = ButtonOptions(
    layerColor: UIColor.clear,
    tagTitleColor: titleColor,
    tagFont: UIFont.systemFont(ofSize: 15),
    tagBackgroundColor: UIColor.clear)
    tagButton.setEntity(options)
    return tagButton
})
self.tagsView.append(contentsOf: tags)
```


## Author

pikachu987, pikachu77769@gmail.com

## License

Tags is available under the MIT license. See the LICENSE file for more info.
