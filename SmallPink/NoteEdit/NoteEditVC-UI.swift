//
//  NoteEditVC-UI.swift
//  SmallPink
//
//  Created by yalan on 2022/4/15.
//

import Foundation
import PopupDialog
extension NoteEditVC{
    func setUI(){
        addPopup()
        setDraftNoteEditUI()//编辑草稿笔记
        setNoteEditUI()//编辑发布了的笔记
    }
    
    
    //编辑草稿笔记时的UI处理
    private func setDraftNoteEditUI(){
        if let draftNote = draftNote{
            titleTextField.text = draftNote.title
            textView.text = draftNote.text
            channel = draftNote.channel!
            subChannel = draftNote.subChannel!
            poiName = draftNote.poiName!
            
            if !subChannel.isEmpty{
                updateChannelUI()
            }
            if !poiName.isEmpty{
                updatePOINameUI()
            }
        }
    }
    
    //编辑笔记时的UI处理
    func setNoteEditUI(){
        if let note = note{
            titleTextField.text = note.getExactStringVal(kTitleCol)
            textView.text = note.getExactStringVal(kTextCol)
            channel = note.getExactStringVal(kChannelCol)
            subChannel = note.getExactStringVal(kSubChannelCol)
            poiName = note.getExactStringVal(kPOINameCol)
            
            if !subChannel.isEmpty{
                updateChannelUI()
            }
            if !poiName.isEmpty{
                updatePOINameUI()
            }
        }
    }
    
    
    func updateChannelUI(){
        channelLabel.text = subChannel
        channelIcon.tintColor = blueColor
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }
    func updatePOINameUI(){
        if poiName == ""{
            poiNameIcon.tintColor = .label
            poiNameLabel.text = "添加地点"
            poiNameLabel.textColor = .label
        }else{
            poiNameLabel.text = self.poiName
            poiNameLabel.textColor = blueColor
            poiNameIcon.tintColor = blueColor
        }
    }
}



extension NoteEditVC{
    private func addPopup(){
        let icon = largeIcon("info.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(showPopup))
        
        let pv = PopupDialogDefaultView.appearance()
        pv.titleColor = .label
        pv.messageFont = .systemFont(ofSize: 13)
        pv.messageColor = .secondaryLabel
        pv.messageTextAlignment = .natural
        
        let cb = CancelButton.appearance()
        cb.titleColor = .label
        cb.separatorColor = mainColor
        
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = .secondarySystemBackground
        pcv.cornerRadius = 10
    }
    
    @objc private func showPopup(){
        let title = "发布小贴士"
        let message =
        """
        小粉书鼓动向上、真实、原创的内容，含以下内容的笔记将不会被推荐
        1.含有不文明语言、过度性感图片；
        2. 含有网址链接、联系方式、二维码或售卖语言；
        3.冒充他人身份或搬运他人作品；
        4.通过有奖方式诱导他人点赞、评论、收藏、转发、关注；
        5.为刻意博取眼球，在标题、封面等处使用夸张表达.
        """
        let popup = PopupDialog(title: title, message: message, transitionStyle: .zoomIn)
        let btn = CancelButton(title: "知道了", action: nil)
        popup.addButton(btn)
        present(popup, animated: true)
    }
}
