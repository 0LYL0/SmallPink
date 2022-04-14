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


// MARK: 瀑布流
let kWaterfallCellID = "WaterfallCellID"
let kPhotoCellID = "PhotoCellID"
let kPhotoFooterViewID = "PhotoFooterViewID"
let kPOIVCCellID = "POIVCCellID"
let kDraftNoteWaterfallCellID = "DraftNoteWaterfallCellID"

let kWaterfallPadding: CGFloat = 4
let kDraftNoteWaterfallCellBottomViewH: CGFloat = 80

// MARK: - 资源文件相关
let mainColor = UIColor(named: "main")!
let blueColor = UIColor(named: "blue")!
let imagePH = UIImage(named: "imagePH")!

// MARK: - CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

// MARK: - UI布局
let screenRect = UIScreen.main.bounds

// MARK: - 业务逻辑相关
let kChannels = ["推荐","旅行","娱乐","才艺","美妆","白富美","美食","萌宠"]
let kMaxPhotoCount = 9 //picker选择照片时允许用户最多选几张

let kSpacingBetweenItems: CGFloat = 2

//笔记
let kMaxNoteTitleCount = 20
let kMaxNoteTextCount = 10

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

let kNoPOIPH = "未知地址"
let kPOITypes = "汽车服务"
//let kPOITypes = "汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施"
let kPOIsInitArr = [["不显示位置", ""]]
let kPOIsOffset = 20
