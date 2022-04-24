//
//  MeVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/15.
//

import UIKit
import LeanCloud

class MeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.backButtonTitle = ""
        navigationItem.backButtonDisplayMode = .minimal
//        navigationController?.navigationBar.tintColor = .label

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutTest(_ sender: Any) {
        LCUser.logOut()
        let loginVC = storyboard!.instantiateViewController(withIdentifier: kLoginVCID)
        loginAndMeParentVC.removeChildren()
        loginAndMeParentVC.add(child: loginVC)
    }
    
    @IBAction func showDraftNotes(_ sender: Any) {
        let navi = storyboard!.instantiateViewController(withIdentifier: kDraftNotesNavID)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
