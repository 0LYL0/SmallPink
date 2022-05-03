//
//  IntroVC.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import UIKit

class IntroVC: UIViewController {
    
    var intro = ""

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.text = intro
        countLabel.text = "\(kMaxIntroCount)"
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func done(_ sender: Any) {
        
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

extension IntroVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }
        countLabel.text = "\(kMaxIntroCount - textView.text.count)"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isExceed = range.location >= kMaxIntroCount || (textView.text.count + text.count > kMaxIntroCount)
        if isExceed{ showTextHUD("个人简介最多输入\(kMaxIntroCount)字哦") }
        return !isExceed
    }
}
