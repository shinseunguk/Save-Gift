//
//  GiftHowToUse.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 사용법ㅋ

import Foundation
import UIKit
import JJFloatingActionButton


class GiftSaveController : UIViewController {
    
    @IBOutlet weak var tabBar: UITabBarItem!
    // MARK: EffectView가 들어갈 View
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: Blur효과가 적용될 EffectView
    var viewBlurEffect:UIVisualEffectView!
    let actionButton = JJFloatingActionButton()
    
    
    var collectionItems = ["1","2","3","4","5","6","7","8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftSaveController viewDidLoad")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        setupFlowLayout()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let width = collectionView.frame.width
//            let height = collectionView.frame.height
//            let itemsPerRow: CGFloat = 2
//            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
//            let itemsPerColumn: CGFloat = 3
//            let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
//            let cellWidth = (width - widthPadding) / itemsPerRow
//            let cellHeight = (height - heightPadding) / itemsPerColumn
//
//            return CGSize(width: cellWidth, height: cellHeight)
//
//        }
    
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        flowLayout.minimumInteritemSpacing = 0 // 좌우 margin
        flowLayout.minimumLineSpacing = 0 // 위아래 margin
        
        let halfWidth = UIScreen.main.bounds.width / 2
//        flowLayout.itemSize = CGSize(width: halfWidth * 0.9 , height: halfWidth * 0.9)
        flowLayout.itemSize = CGSize(width: halfWidth * 1 , height: halfWidth * 1)
        flowLayout.footerReferenceSize = CGSize(width: halfWidth * 3, height: 70)
        flowLayout.sectionFootersPinToVisibleBounds = true
        self.collectionView.collectionViewLayout = flowLayout
    }

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
}

extension GiftSaveController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionItems.count ", collectionItems.count)
        return collectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("indexPath... ", indexPath)
        print("collectionItems[indexPath.row]... ", collectionItems[indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        //  Configure the Cell
        cell.collectionLabel.text = collectionItems[indexPath.row]
        return cell
    }
    
    
}
