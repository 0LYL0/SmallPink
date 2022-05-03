//
//  CustomViews.swift
//  SmallPink
//
//  Created by yalan on 2022/4/24.
//

import Foundation
import UIKit

@IBDesignable
class BigButton: UIButton{
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        shareInit()
    }
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not bean implemented")
        super.init(coder: coder)
        shareInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        shareInit()
    }
    
    private func shareInit(){
        backgroundColor = .secondarySystemBackground
        tintColor = .placeholderText
        setTitleColor(.placeholderText, for: .normal)
        
        contentHorizontalAlignment = .leading
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}
