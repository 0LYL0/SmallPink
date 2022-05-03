//
//  NoteDetailVC-Config.swift
//  SmallPink
//
//  Created by yalan on 2022/4/24.
//

import ImageSlideshow
import UIKit
import Foundation
import GrowingTextView
import LeanCloud
extension NoteDetailVC{
    func config(){
                
        //imageSlideshow
        imageSlideshow.zoomEnabled = true
        imageSlideshow.circular = false
        imageSlideshow.contentScaleMode = .scaleAspectFill
        imageSlideshow.activityIndicator = DefaultActivityIndicator()
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = mainColor
        pageControl.pageIndicatorTintColor = .systemGray
        imageSlideshow.pageIndicator = pageControl
        
        if LCApplication.default.currentUser == nil{
            likeBtn.setToNormal()
            favBtn.setToNormal()
        }
        
        //textView
        textView.textContainerInset = UIEdgeInsets(top: 11.5, left: 16, bottom: 11.5, right: 16)
        textView.delegate = self
        
        //添加观察者,监听键盘的弹出和收起
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommentView", bundle: nil), forHeaderFooterViewReuseIdentifier: kCommentViewID)
        tableView.register(CommentSectionFooterView.self, forHeaderFooterViewReuseIdentifier: kCommentSectionFooterViewID)
        
        
    }
    func adjustTableHeaderViewHeight(){
        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = tableHeaderView.frame
        if frame.height != height{
            frame.size.height = height
            tableHeaderView.frame = frame
        }
    }
}
extension NoteDetailVC: GrowingTextViewDelegate{
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension NoteDetailVC{
    @objc private func keyboardWillChangeFrame(_ notification: Notification){
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            let keyboardH = screenRect.height - endFrame.origin.y
            
            if keyboardH > 0{
                view.insertSubview(overlayView, belowSubview: textViewBarView)
            }else{
                overlayView.removeFromSuperview()
                textViewBarView.isHidden = true
            }
            
            textViewBarBottomConstraint.constant = keyboardH
            view.layoutIfNeeded()
        }
    }
}
