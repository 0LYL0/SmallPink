//
//  NoteDetailVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/24.
//

import UIKit
import ImageSlideshow
import LeanCloud
import FaveButton
import GrowingTextView

class NoteDetailVC: UIViewController {
    var note: LCObject
    var isLikeFromWaterfallCell = false
    var delNoteFinished: (() -> ())?
    
    var comments: [LCObject] = []
    
    var isReply = false//是区分是评论还是回复
    var commentSection = 0
    
    var replies: [ExpandableReplies] = []
    var replyToUser: LCUser?
    
    var isFromMeVC = false
    var fromMeVCUser: LCUser?
    
    @IBOutlet weak var authorAvatarBtn: UIButton!
    @IBOutlet weak var authorNikeNameBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var shareOrMoreBtn: UIButton!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var imageSlideshowHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var channelBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var likeBtn: FaveButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var favBtn: FaveButton!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var commentCountBtn: UIButton!
    
    @IBOutlet weak var textViewBarView: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewBarBottomConstraint: NSLayoutConstraint!
    
    lazy var overlayView: UIView = {
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        overlayView.addGestureRecognizer(tap)
        return overlayView
    }()
    
    var likeCount = 0{
        didSet{
            likeCountLabel.text = likeCount == 0 ? "点赞" : likeCount.formattedStr
        }
    }
    var currentLikeCount = 0
    var favCount = 0{
        didSet{
            favCountLabel.text = favCount == 0 ? "收藏" : favCount.formattedStr
        }
    }
    var currentFavCount = 0
    
    var commentCount = 0{
        didSet{
            commentCountLabel.text = "\(commentCount)"
            commentCountBtn.setTitle(commentCount == 0 ? "评论" : commentCount.formattedStr, for: .normal)
        }
    }
    
    //计算属性
    var author: LCUser?{ note.get(kAuthorCol) as? LCUser }
    var isLike: Bool { likeBtn.isSelected }
    var isFav: Bool { favBtn.isSelected }
    var isReadMyNote: Bool {
        if let user = LCApplication.default.currentUser, let author = author, user == author{
            return true
        }else{
            return false
        }
    }
    
    
    init?(coder: NSCoder, note: LCObject){
        self.note = note
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
        setUI()
        
        getCommentsAndReplies()
        getFav()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTableHeaderViewHeight()
    }
    
    @IBAction func goToAuthorMeVc(_ sender: Any) {
        noteToMeVC(author)
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func shareOrMore(_ sender: Any) {
        shareOrMore()
    }
    //点赞
    @IBAction func like(_ sender: Any) {
        like()
    }
    //收藏
    @IBAction func fav(_ sender: Any) {
        fav()
    }
    //评论
    @IBAction func comment(_ sender: Any) {
        comment()
    }
    //发送评论
    @IBAction func postCommentOrReply(_ sender: Any) {
        if !textView.isBlank{
            if !isReply{
                postComment()
                
            }else{
                postReply()
            }
            
            hideAndResetTextView()
        }
    }
}
