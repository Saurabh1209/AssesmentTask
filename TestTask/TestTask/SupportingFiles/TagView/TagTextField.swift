//
//  TagTextField.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 01/10/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import UIKit

open class TagTextField: UITextField {
    
    open var paddingY: CGFloat = 0
    
    open var paddingX: CGFloat = 0
    
    // MARK: - layout
    
    override open var intrinsicContentSize: CGSize {
        var size = CGSize.zero
        if let textFont  = self.font,
            let placeholder = self.placeholder {
            size = placeholder.size(withAttributes: [NSAttributedString.Key.font: textFont])
            size.height = textFont.pointSize + paddingY * 2
            size.width += paddingX * 2
        }
        return size
    }
}
