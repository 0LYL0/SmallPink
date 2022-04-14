//
//  WaterfallVC-loadData.swift
//  SmallPink
//
//  Created by yalan on 2022/4/14.
//

import Foundation
import CoreData
extension WaterfallVC{
    func loadDriftNotes(){
        let request = DraftNote.fetchRequest() as NSFetchRequest<DraftNote>
        //分页
//        request.fetchOffset = 0
//        request.fetchLimit = 20
        //筛选
//        request.predicate = NSPredicate(format: "title = %@", "iOS")
        
        //排序
        let sortDescriptor1 = NSSortDescriptor(key: "updateAt", ascending: false)
        request.sortDescriptors = [sortDescriptor1]
        
//        request.returnsDistinctResults
        
        let draftNotes = try! context.fetch(request)
        self.draftNotes = draftNotes
    }
}
