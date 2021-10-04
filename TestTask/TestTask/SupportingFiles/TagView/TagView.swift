//
//  TagView.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 01/10/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import UIKit

open class TagView: UIButton {
    
    open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    open var borderColor: UIColor = .blue {
        didSet {
            reloadStyles()
        }
    }
    
    open var tagBackgroundColor: UIColor = .gray {
        didSet {
            reloadStyles()
        }
    }
    
    open var textColor: UIColor = .systemYellow {
        didSet {
            reloadStyles()
        }
    }
    
    open var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            titleLabel?.font = textFont
        }
    }
    
    open var titleLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            titleLabel?.lineBreakMode = titleLineBreakMode
        }
    }
    
    open var paddingY: CGFloat  = 0 {
        didSet {
            titleEdgeInsets.top = paddingY
            titleEdgeInsets.bottom = paddingY
        }
    }
    
    open var paddingX: CGFloat = 0 {
        didSet {
            titleEdgeInsets.left = paddingX
            updateRightInsets()
        }
    }
    
    open var removeButtonIconSize: CGFloat = 0 {
        didSet {
            removeButton.iconSize = removeButtonIconSize
            updateRightInsets()
        }
    }
    
    open var removeIconLineWidth: CGFloat = 0 {
        didSet {
            removeButton.lineWidth = removeIconLineWidth
        }
    }
    
    open var removeIconLineColor: UIColor = .gray {
        didSet {
            removeButton.lineColor = removeIconLineColor
        }
    }
    
    private func reloadStyles() {
        backgroundColor = tagBackgroundColor
        layer.borderColor = borderColor.cgColor
        setTitleColor(textColor, for: .normal)
    }
    
    let removeButton = CloseButton()
    
    // MARK: - init
    
    public init(title: String) {
        super.init(frame: CGRect.zero)
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        titleLabel?.lineBreakMode = titleLineBreakMode
        frame.size = intrinsicContentSize
        addSubview(removeButton)
        removeButton.tagView = self
    }
    
    // MARK: - layout
    
    override open var intrinsicContentSize: CGSize {
        var size = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: textFont]) ?? CGSize.zero
        size.height = textFont.pointSize + paddingY * 2
        size.width += paddingX * 2
        if size.width < size.height {
            size.width = size.height
        }
        // with removeButton
        size.width += removeButtonIconSize + paddingX
        return size
    }
    
    private func updateRightInsets() {
        // with removeButton
        titleEdgeInsets.right = paddingX  + removeButtonIconSize + paddingX
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        // with removeButton
        removeButton.frame.size.width = paddingX + removeButtonIconSize + paddingX
        removeButton.frame.origin.x = self.frame.width - removeButton.frame.width
        removeButton.frame.size.height = self.frame.height
        removeButton.frame.origin.y = 0
    }
}

internal class CloseButton: UIButton {
    
    var iconSize: CGFloat = 0
    var lineWidth: CGFloat = 0
    var lineColor: UIColor = .blue
    
    weak var tagView: TagView?
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        
        let iconFrame = CGRect(
            x: (rect.width - iconSize) / 2.0,
            y: (rect.height - iconSize) / 2.0,
            width: iconSize,
            height: iconSize
        )
        
        path.move(to: iconFrame.origin)
        path.addLine(to: CGPoint(x: iconFrame.maxX, y: iconFrame.maxY))
        path.move(to: CGPoint(x: iconFrame.maxX, y: iconFrame.minY))
        path.addLine(to: CGPoint(x: iconFrame.minX, y: iconFrame.maxY))
        
        lineColor.setStroke()
        
        path.stroke()
    }
    
}
