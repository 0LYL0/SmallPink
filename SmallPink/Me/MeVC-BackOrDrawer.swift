//
//  MeVC-BackOrDrawer.swift
//  SmallPink
//
//  Created by yalan on 2022/5/2.
//

import Foundation
import UIKit
extension MeVC{
    @objc func backOrDrawer(_ sender: UIButton){
        if isFromNote{
            dismiss(animated: true, completion: nil)
        }else{
            
        }
    }
}
