//
//  TagListView.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 01/10/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import UIKit

/// This custom UIView will display a list of tags and a textField
open class TagListView: UIView {
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: Public fields
    
    open var tagTextColor: UIColor = UIColor.white {
        didSet {
            for tagView in tagViews {
                tagView.textColor = tagTextColor
            }
        }
    }
    
    open var textFieldColor: UIColor = UIColor.white {
        didSet {
            textField.textColor = textFieldColor
        }
    }
    
    open var tagTextFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            for tagView in tagViews {
                tagView.textFont = tagTextFont
            }
            textField.font = tagTextFont
            rearrangeViews()
        }
    }
    
    open var tagLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            for tagView in tagViews {
                tagView.titleLineBreakMode = tagLineBreakMode
            }
        }
    }
    
    open var tagBackgroundColor: UIColor = UIColor.init(hexFromString: "1a2c60"){
        didSet {
            for tagView in tagViews {
                tagView.tagBackgroundColor = tagBackgroundColor
            }
        }
    }
    
    open var tagCornerRadius: CGFloat = 15 {
        didSet {
            for tagView in tagViews {
                tagView.cornerRadius = tagCornerRadius
            }
        }
    }
    
    open var tagBorderWidth: CGFloat = 0 {
        didSet {
            for tagView in tagViews {
                tagView.borderWidth = tagBorderWidth
            }
        }
    }
    
    open var tagBorderColor: UIColor = UIColor.blue {
        didSet {
            for tagView in tagViews {
                tagView.borderColor = tagBorderColor
            }
        }
    }
    
    open var paddingY: CGFloat = 8 {
        didSet {
            for tagView in tagViews {
                tagView.paddingY = paddingY
            }
            textField.paddingY = paddingY
            rearrangeViews()
        }
    }
    
    open var paddingX: CGFloat = 12 {
        didSet {
            for tagView in tagViews {
                tagView.paddingX = paddingX
            }
            textField.paddingX = paddingX
            rearrangeViews()
        }
    }
    
    open var marginY: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    
    open var marginX: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    
    open var removeButtonIconSize: CGFloat = 14 {
        didSet {
            for tagView in tagViews {
                tagView.removeButtonIconSize = removeButtonIconSize
            }
            rearrangeViews()
        }
    }
    
    open var removeIconLineWidth: CGFloat = 3 {
        didSet {
            for tagView in tagViews {
                tagView.removeIconLineWidth = removeIconLineWidth
            }
            rearrangeViews()
        }
    }
    
    open var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            for tagView in tagViews {
                tagView.removeIconLineColor = removeIconLineColor
            }
            rearrangeViews()
        }
    }
    
    
    /// Placeholder while tag list is empty
    open var emptyPlaceholder: String = "Start typing..." {
        didSet {
            rearrangeViews()
        }
    }
    
    /// Placeholder while tag list is not empty
    open var morePlaceholder: String = "Add another" {
        didSet {
            rearrangeViews()
        }
    }
    
    /// Object that handle delegate methods
    open weak var delegate: TagListViewDelegate?
    
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: Init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 0
        textField.textColor = UIColor.white
        textField.delegate = self
        textField.returnKeyType = .search
        textField.paddingX = paddingX
        textField.paddingY = paddingY
        textField.font = tagTextFont
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: Interface Builder
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addTag("This")
        addTag("is")
        addTag("TagListView")
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: Private implementation
    
    private let textField = TagTextField()
    private(set) var tagViews: [TagView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0
    
    private func rearrangeViews() {
        
        let views = tagViews as [UIView] + rowViews
        for view in views {
            view.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        
        var childViews: [UIView] = []
        for tagView in tagViews {
            childViews.append(tagView)
        }
        childViews.append(textField)
        
        
        textField.attributedPlaceholder = NSAttributedString(string: (tagViews.count == 0 ? "enter search term here" : "add another search term"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hexFromString: "7886a1")])
        
        for view in childViews {
            
            var size = view.intrinsicContentSize
            
            if currentRowTagCount == 0 || (currentRowWidth + size.width + 2 * marginX) > frame.width {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                
                currentRowView.frame.origin = CGPoint(x: marginX, y: marginY + CGFloat(currentRow - 1) * (tagViewHeight + marginY))
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)
                
                size.width = min(size.width, frame.width - 2 * marginX)
            }
            
            if view is UITextField {
                size.width = max(size.width, frame.width - 2 * marginX - currentRowWidth)
            }
            
            view.frame.size = size
            view.frame.origin = CGPoint(x: currentRowWidth, y: 0)
            tagViewHeight = size.height
            
            currentRowView.addSubview(view)
            
            currentRowTagCount += 1
            currentRowWidth += view.frame.width + marginX
            
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow
        
        invalidateIntrinsicContentSize()
    }
    
    private func createNewTagView(_ title: String) -> TagView {
        let tagView = TagView(title: title)
        
        tagView.textColor = tagTextColor
        tagView.tagBackgroundColor = tagBackgroundColor
        tagView.titleLineBreakMode = tagLineBreakMode
        tagView.cornerRadius = tagCornerRadius
        tagView.borderWidth = tagBorderWidth
        tagView.borderColor = tagBorderColor
        tagView.paddingX = paddingX
        tagView.paddingY = paddingY
        tagView.textFont = tagTextFont
        tagView.removeIconLineWidth = removeIconLineWidth
        tagView.removeButtonIconSize = removeButtonIconSize
        tagView.removeIconLineColor = removeIconLineColor
        tagView.removeButton.addTarget(self, action: #selector(removeButtonPressed(_:)), for: .touchUpInside)
        
        return tagView
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        rearrangeViews()
    }
    
    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(0)
        if rows > 0 {
            height =  CGFloat(rows) * (tagViewHeight + marginY) + marginY
        }
        return CGSize(width: frame.width, height: height)
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: Public interface
    
    open func addTags(_ titles: [String]) -> [TagView] {
        var tagViews: [TagView] = []
        for title in titles {
            tagViews.append(createNewTagView(title))
        }
        return addTagViews(tagViews)
    }
    
    open func addTagViews(_ tagViews: [TagView]) -> [TagView] {
        for tagView in tagViews {
            self.tagViews.append(tagView)
        }
        rearrangeViews()
        return tagViews
    }
    
    open func addTagView(_ tagView: TagView) {
        tagViews.append(tagView)
        rearrangeViews()
    }
    
    open func insertTagView(_ tagView: TagView, at index: Int) {
        tagViews.insert(tagView, at: index)
        rearrangeViews()
    }
    
    open func removeTagView(_ tagView: TagView) {
        tagView.removeFromSuperview()
        if let index = tagViews.index(of: tagView) {
            tagViews.remove(at: index)
        }
        
        rearrangeViews()
    }
    
    open func addTag(_ title: String) {
        addTagView(createNewTagView(title))
    }
    
    open func insertTag(_ title: String, at index: Int) {
        insertTagView(createNewTagView(title), at: index)
    }
    
    open func removeAllTags() {
        for view in tagViews {
            view.removeFromSuperview()
        }
        tagViews = []
        rearrangeViews()
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: Events
    
    @objc func removeButtonPressed(_ closeButton: CloseButton!) {
        if let tagView = closeButton.tagView {
            self.removeTagView(tagView)
            delegate?.tagListView(self, didRemove: tagView.currentTitle ?? "")
        }
    }
}

////////////////////////////////////////////////////////////////////////
// MARK: UITextFieldDelegate

extension TagListView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.addTag(text)
            delegate?.tagListView(self, didAdd: text)
            textField.text = ""
        }
        return false
    }
}

////////////////////////////////////////////////////////////////////////
// MARK: Delegate protocol

public protocol TagListViewDelegate: class {
    
    func tagListView(_ sender: TagListView, didAdd title: String)
    func tagListView(_ sender: TagListView, didRemove title: String)
}
