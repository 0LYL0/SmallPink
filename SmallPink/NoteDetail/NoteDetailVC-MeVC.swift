//
//  NoteDetailVC-MeVC.swift
//  SmallPink
//
//  Created by yalan on 2022/5/2.
//

import Foundation
import LeanCloud
extension NoteDetailVC{
    func noteToMeVC(_ user: LCUser?){
        guard let user = user else {
            return
        }
        if isFromMeVC, let fromMeVCUser = fromMeVCUser, fromMeVCUser == user{
            dismiss(animated: true, completion: nil)
        }else{
            
            let meVC = storyboard!.instantiateViewController(identifier: kMeVCID){ coder in
                MeVC(coder: coder, user: user)
            }
            meVC.isFromNote = true
            meVC.modalPresentationStyle = .fullScreen
            present(meVC, animated: true, completion: nil)
        }
       
    }
    @objc func goToMeVC(_ tap: UIPassableTapGestureRecognizer){
        let user = tap.passObj
        noteToMeVC(user)
    }
}
