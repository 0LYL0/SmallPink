//
//  WaterfallVC-loadData.swift
//  SmallPink
//
//  Created by yalan on 2022/4/14.
//

import Foundation
import CoreData
import LeanCloud

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
        showLoadHUD()
        backgroundContext.perform {
            if let draftNotes = try? backgroundContext.fetch(request){
                self.draftNotes = draftNotes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.header.endRefreshing()
            }
            self.hideLoadHUD()
        }
        
        
    }
    @objc func getNotes(){
        let query = LCQuery(className: kNoteTable)
        
        query.whereKey(kChannelCol, .equalTo(channel))
        query.whereKey(kAuthorCol, .included)
        query.whereKey(kUpdatedAtCol, .descending)
        query.limit = kNotesOffSet
        
        query.find { result in
            if case let .success(objects: notes) = result{
                self.notes = notes
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.header.endRefreshing()
            }
        }
    }
    @objc func getMyNotes(){
        let query = LCQuery(className: kNoteTable)
        
        query.whereKey(kAuthorCol, .equalTo(user!))
        query.whereKey(kAuthorCol, .included)
        query.whereKey(kUpdatedAtCol, .descending)
        query.limit = kNotesOffSet
        
        query.find { result in
            if case let .success(objects: notes) = result{
                self.notes = notes
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.header.endRefreshing()
            }
        }
    }
    @objc func getMyFavNotes(){
        getLikeOrFav(kUserFavTable)
    }
    @objc func getMyLikeNotes(){
        getLikeOrFav(kUserLikeTable)
    }
    private func getLikeOrFav(_ className: String){
        let query = LCQuery(className: className)
        query.whereKey(kUserCol, .equalTo(user!))
        query.whereKey(kNoteCol, .selected)
        query.whereKey(kNoteCol, .included)
        query.whereKey("\(kNoteCol).\(kAuthorCol)", .included)
        query.whereKey(kUpdatedAtCol, .descending)
        query.limit = kNotesOffSet
        query.find { res in
            if case let .success(objects: userLikeOrFavs) = res{
                self.notes = userLikeOrFavs.compactMap{ $0.get(kNoteCol) as? LCObject }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.header.endRefreshing()
            }
        }
    }
}
