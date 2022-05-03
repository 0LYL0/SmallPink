//
//  LC-Extensions.swift
//  SmallPink
//
//  Created by yalan on 2022/4/23.
//

import LeanCloud
import Foundation

extension LCFile{
    func save(to table: LCObject, as record: String, group: DispatchGroup? = nil){
        group?.enter()
        self.save{ (result) in
            switch result {
            case .success:
                // 保存后的操作
                if let _ = self.objectId?.value{
//                    print("文件保存完成,objectId:\(value)")
                    
                    do {
                        try table.set(record, value: self)
                        group?.enter()
                        table.save{ result in
                            switch result {
                            case .success:
                                print("文件已关联/文件已存入\(record)字段")
                                break
                            case .failure(let error):
                                print("保存表的数据失败\(error)")
                            }
                            group?.leave()
                        }
                        
                    } catch {
                        print("给字段赋值失败\(error)")
                    }
                }
                
            case .failure(error: let error):
                print("保存文件失败\(error)")
            }
            group?.leave()
        }
    }
}
extension LCObject{
    func getExactStringVal(_ col: String) -> String{ get(col)?.stringValue ?? "" }
    func getExactIntVal(_ col: String) -> Int{ get(col)?.intValue ?? 0 }
    func getExactDoubleVal(_ col: String) -> Double{ get(col)?.doubleValue ?? 1 }
    func getExactBoolValDefaultF(_ col: String) -> Bool{ get(col)?.boolValue ?? false }
    func getExactBoolValDefaultT(_ col: String) -> Bool{ get(col)?.boolValue ?? true }
    
    enum imageType{
        case avator
        case coverPhoto
    }
    //从云端的某个file(image类型)字段取出path再变成URL
    func getImageURL(from col: String, _ type: imageType) -> URL{
//        let file = get(col) as? LCFile
//        let path = file?.url?.stringValue
//        print(path)
        
        if let file = get(col) as? LCFile, let path = file.url?.stringValue, let url = URL(string: path){
            return url
        }else{
            switch type {
            case .avator:
                return Bundle.main.url(forResource: "avatarPH", withExtension: "png")!
            case .coverPhoto:
                return Bundle.main.url(forResource: "imagePH", withExtension: "png")!
            }
        }
    }
    static func userInfo(where userObjectId: String, increase col: String){
        let query = LCQuery(className: kUserInfoTable)
        query.whereKey(kUserObjectIdCol, .equalTo(userObjectId))
        query.getFirst{ res in
            if case let .success(object: userInfo) = res{
                try? userInfo.increase(col)
                userInfo.save { _ in }
            }
        }
    }
    static func userInfo(where userObjectId: String, decrease col: String, to: Int){
        let query = LCQuery(className: kUserInfoTable)
        query.whereKey(kUserObjectIdCol, .equalTo(userObjectId))
        query.getFirst{ res in
            if case let .success(object: userInfo) = res{
                try? userInfo.set(col, value: to)
                userInfo.save{ _ in }
            }
        }
    }
}
