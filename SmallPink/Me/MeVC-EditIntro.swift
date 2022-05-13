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
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}
extension MeVC: IntroVCDelegate{
    func updateIntro(_ intro: String) {
        //UI
        meHeaderView.introLabel.text = intro.isEmpty ? kIntroPH : intro
        
        //云端
        try? user.set(kIntroCol, value: intro)
        user.save{ _ in }
    }
}
