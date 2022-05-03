//
//  NoteEditVC-Config.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import Foundation
extension NoteEditVC{
    func config(){
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.dragDelegate = self
        photoCollectionView.dropDelegate = self
        photoCollectionView.dragInteractionEnabled = true//开启拖拽交互
        
        titleTextField.delegate = self
        hideKeyboardWhenTappedAround()
        titleCountLabel.text = "\(kMaxNoteTitleCount)"
        
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -textView.textContainer.lineFragmentPadding, bottom: 0, right: -textView.textContainer.lineFragmentPadding)//去除文本边距
//        textView.textContainer.lineFragmentPadding = 0//去除内容缩进,左右边距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let typingAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        textView.typingAttributes = typingAttributes
        //光标颜色
        textView.tintColorDidChange()
        
//        if let textViewIAView = Bundle.main.loadNibNamed("TextViewIAView", owner: nil, options: nil)?.first as? TextViewIAView{
        
        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", with: TextViewIAView.self)
        textViewIAView.doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
        textViewIAView.maxTextCountLabel.text = "/\(kMaxNoteTextCount)"
//        }
        textView.delegate = self
        
        // MARK: 请求位置权限
        locationManager.requestWhenInUseAuthorization()
        AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        
//        print(NSHomeDirectory())
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
}
