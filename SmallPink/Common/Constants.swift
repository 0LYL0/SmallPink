//
//  Constants.swift
//  SmallPink
//
//  Created by yalan on 2022/4/8.
//

import UIKit

// MARK: 首页storyboard的id
let kFollowVCID = "FollowVCID"
let kDiscoverVCID = "DiscoverVCID"
let kNearbyVCID = "NearbyVCID"
let kWaterfallVCID = "WaterfallVCID"
let kChannelTableVCID = "ChannelTableVCID"
let kSubChannelCellID = "SubChannelCellID"
let kNoteEditVCID = "NoteEditVCID"
let kLoginNavID = "LoginNavID"
let kLoginVCID = "LoginVCID"
let kMeVCID = "MeVCID"
let kDraftNotesNavID = "DraftNotesNavID"
let kAuthorCol = "author"
let kNoteDetailVCID = "NoteDetailVCID"
let kIntroVCID = "IntroVCID"
let kEditProfileNavID = "EditProfileNavID"
let kSettingTableVCID = "SettingTableVCID"

// Cell相关ID
let kWaterfallCellID = "WaterfallCellID"
let kPhotoCellID = "PhotoCellID"
let kPhotoFooterViewID = "PhotoFooterViewID"
let kPOIVCCellID = "POIVCCellID"
let kDraftNoteWaterfallCellID = "DraftNoteWaterfallCellID"
let kMyDraftNoteWaterfallCellID = "MyDraftNoteWaterfallCellID"
let kCommentViewID = "CommentViewID"
let kReplyCellID = "ReplyCellID"
let kCommentSectionFooterViewID = "CommentSectionFooterViewID"

let kWaterfallPadding: CGFloat = 4
let kDraftNoteWaterfallCellBottomViewH: CGFloat = 69
let kWaterfallCellBottomViewH: CGFloat = 64

// MARK: - 资源文件相关
let mainColor = UIColor(named: "main")!
let mainLightColor = UIColor(named: "main-light")!
let blueColor = UIColor(named: "blue")!
let imagePH = UIImage(named: "imagePH")!

// MARK: - UserDefaults
let kNameFromAppleID = "nameFromAppleID"
let kEmailFromAppleID = "emailFromAppleID"
let kDraftNoteCount = "draftNoteCount"
let kUserInterfaceStyle = "userInterfaceStyle"
// MARK: - CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let persistentContainer = appDelegate.persistentContainer
let context = persistentContainer.viewContext
let backgroundContext = persistentContainer.newBackgroundContext()

// MARK: - UI布局
let screenRect = UIScreen.main.bounds


// MARK: - 业务逻辑相关
let kChannels = ["推荐","旅行","娱乐","才艺","美妆","白富美","美食","萌宠"]
let kMaxPhotoCount = 9 //picker选择照片时允许用户最多选几张

let kSpacingBetweenItems: CGFloat = 2

//笔记
let kMaxNoteTitleCount = 20
let kMaxNoteTextCount = 2000
let kNoteCommentPH = "精彩评论将被优先展示哦"

//用户  
let kMaxIntroCount = 100
let kIntroPH = "填写个人简介更容易获得关注哦,点击此处填写"
let kNoCachePH = "无缓存"

//话题
let kAllSubChannels = [
    ["穿神马是神马", "就快瘦到50斤啦", "花5个小时修的靓图", "网红店入坑记"],
    ["魔都名媛会会长", "爬行西藏", "无边泳池只要9块9"],
    ["小鲜肉的魔幻剧", "国产动画雄起"],
    ["练舞20年", "还在玩小提琴吗,我已经尤克里里了哦", "巴西柔术", "听说拳击能减肥", "乖乖交智商税吧"],
    ["粉底没有最厚,只有更厚", "最近很火的法属xx岛的面霜"],
    ["我是白富美你是吗", "康一康瞧一瞧啦"],
    ["装x西餐厅", "网红店打卡"],
    ["我的猫儿子", "我的猫女儿", "我的兔兔"]
]

//高德
let kMapApiKey = "3b316aa3ba23ec7a06d76b89366420da"
let kNoPOIPH = "未知地址"
let kPOITypes = "汽车服务"
//let kPOITypes = "汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施"
let kPOIsInitArr = [["不显示位置", ""]]
let kPOIsOffset = 20

//极光
let kJAppKey = "c3ccaa1e0607a89503d25240"

//支付宝
let kAliPayAppID = "2021003127629267"
let kAliPayPID = ""
let kAliPayPrivateKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkcJ/MnzAfRvMRcDyTiPThIbKKi+2rOKFfy8QZoGY6QWzqOl/C83jhLIgnh7XZKBOjGBKZvqBtWeGew7E6GHxqDwxmUhruFTILXdATEGqvvkU2glf23yPf3XV/MRZ5BzFhXynfhkqusoXP1tGNfn0ma4pHTqy9ykvMGXMKjDEj7Yghj90wsp9FOmjF/z4ve/CKPEPkNjWaDcWCIjWbwyxN6MF44gy1GdFeuf997y7RBm21oZ24piR0VRJ+M4mDAL/EJbsSAy2d2b0RSaDs5scmLtJV2GEQKiFf0xoJTAPH2NpEB2cXmt/AieL4uH6vswmF2AfIVaDogv7e/YGZzTm8QIDAQAB"
let kAppScheme = "SmallPink"



//正则表达式
let KPhoneRegEx = "^1\\d{10}$"
let KAuthCodeRegEx = "^\\d{6}$"
let kPasswordRegEx = "^[0-9a-zA-Z]{6,16}$"

//云端
let kNotesOffSet = 10
let kCommentsOffSet = 10

// MARK: - LeanCloud
//配置相关
let kLCAppID = "zovdPXOhUco3KLBcxxhmFXEi-gzGzoHsz"
let kLCAppKey = "4WCseRsVaA3Vzsb4u1yNtWI8"
let kLCServerURL = "https://zovdpxoh.lc-cn-n1-shared.com"

//通用字段
let kCreatedAtCol = "createdAt"
let kUpdatedAtCol = "updatedAt"

//表
let kNoteTable = "Note"
let kUserLikeTable = "UserLike"
let kUserFavTable = "UserFav"
let kCommentTable = "Comment"
let kReplyTable = "Reply"
let kUserInfoTable = "UserInfo"

//User表
let kNickNameCol = "nickName"
let kAvatarCol = "avatar"
let kIDCol = "id"
let kGenderCol = "gender"
let kIntroCol = "intro"
let kBirthCol = "birth"
let kIsSetPasswordCol = "isSetPassword"


//Note表
let kCoverPhotoCol = "coverPhoto"
let kCoverPhotoRatioCol = "coverPhotoRatio"
let kPhotosCol = "photos"
let kVideoCol = "video"
let kTitleCol = "title"
let kTextCol = "text"
let kChannelCol = "channel"
let kSubChannelCol = "subChannel"
let kPOINameCol = "poiName"
let kIsVideoCol = "isVideo"
let kLikeCountCol = "likeCount"
let kFavCountCol = "favCount"
let kCommentCountCol = "commentCount"
let kHasEditCol = "hasEdit"

//UserLike表
let kUserCol = "user"
let kNoteCol = "note"

//Comment表
let kHasReplyCol = "hasReply"

//Reply表
let kCommentCol = "comment"
let kReplyToUserCol = "replyToUser"

//UserInfo表
let kUserObjectIdCol = "userObjectId"
let kNoteCountCol = "noteCount"


// MARK: - 全局函数
func largeIcon(_ iconName: String, with color: UIColor = .label) -> UIImage{
    let config = UIImage.SymbolConfiguration(scale: .large)
    let icon = UIImage(systemName: iconName, withConfiguration: config)!
    return icon.withTintColor(color)
}
func fontIcon(_ iconName: String, fontSize: CGFloat, with color: UIColor = .label) -> UIImage{
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: fontSize))
    let icon = UIImage(systemName: iconName, withConfiguration: config)!
    return icon.withTintColor(color)
}
func showGlobalTextHUD(_ title: String){
    let window = UIApplication.shared.windows.last!
    let hud = MBProgressHUD.showAdded(to: window, animated: true)
    hud.mode = .text
    hud.label.text = title
    hud.hide(animated: true, afterDelay: 2)
}
