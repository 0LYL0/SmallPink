//
//  NoteEditVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/11.
//

import UIKit

class NoteEditVC: UIViewController {
    
    let photos = [
        UIImage(named: "1"), UIImage(named: "2")
    ]

    @IBOutlet weak var photoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
    }
    
}
extension NoteEditVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoCell
        cell.imageView.image = photos[indexPath.row]
//        cell.contentView.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterViewID, for: indexPath) as! PhotoFooterView
            photoFooter.addPhotoBtn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            return photoFooter
        default:
            fatalError("collectionView的footer出问题了")
        }
    }
    
    
}

extension NoteEditVC: UICollectionViewDelegate{
    
}

extension NoteEditVC{
    @objc private func addPhoto(){
        print("点击了+")
    }
}



