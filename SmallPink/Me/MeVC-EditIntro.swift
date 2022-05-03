//
//  MeVC-EditIntro.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import Foundation
extension MeVC{
    @objc func editIntro(){
        let vc = storyboard!.instantiateViewController(identifier: kIntroVCID) as! IntroVC
        vc.intro = user.getExactStringVal(kIntroCol)
        present(vc, animated: true, completion: nil)
    }
}
