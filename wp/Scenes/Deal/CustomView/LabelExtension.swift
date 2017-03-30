//
//  LabelExtension.swift
//  wp
//
//  Created by J-bb on 17/3/29.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import Foundation

class TriLabel:UILabel {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsDisplay()
    }
    
    
    
    open override func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter) {
        
        let bezierPath = UIBezierPath()
        let color = UIColor.white
        color.setFill()
        bezierPath.move(to: CGPoint(x: 10, y: frame.size.height))
        bezierPath.addLine(to: CGPoint(x: 13.5, y: frame.size.height + 5))
        bezierPath.addLine(to: CGPoint(x: 17, y: frame.size.height))
        bezierPath.close()
        bezierPath.fill()
    }
    
}

extension UILabel {
    func setAttributeText(text:String,firstFont:CGFloat, secondFont:CGFloat, firstColor:UIColor, secondColor:UIColor, range:NSRange) {
        textColor = firstColor
        font = UIFont.systemFont(ofSize: firstFont)
        let attributeText = NSMutableAttributedString(string: text)
        let attributes:[String : AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: secondFont), NSForegroundColorAttributeName : secondColor]
        attributeText.addAttributes(attributes, range: range)
        attributedText = attributeText
    }
}
