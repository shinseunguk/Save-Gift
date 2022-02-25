//
//  GiftHowToUse.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 사용법ㅋ

import Foundation
import UIKit
import JJFloatingActionButton
import DropDown


class GiftSaveController : UIViewController {
    
    @IBOutlet weak var tabBar: UITabBarItem!
    // MARK: EffectView가 들어갈 View
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: Blur효과가 적용될 EffectView
    var viewBlurEffect:UIVisualEffectView!
    let actionButton = JJFloatingActionButton()
    let cellHeight3 = ((UIScreen.main.bounds.width / 2) + 50) / 3
    
    var barndNameLabelArr = ["BHC","BBQ","피자나라 치킨공주","교촌치킨","60계치킨","처갓집양념치킨","호식이두마리치킨","꾸브라꼬숯불두마리치킨"]
    var expirationPeriodLabelArr = ["2022-04-14","2022-04-15","2022-04-16","2022-04-19","2022-04-20","2022-05-14","2022-02-14","2022-04-30"]
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftSaveController viewDidLoad")
        print("cellWidth/3 : ", cellHeight3)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        //드롭다운 btn
        dropDown.dataSource = ["피자", "치킨", "족발보쌈", "치즈돈까스", "햄버거"]
        
//        let ok = UIAction(title: "유효기간 임박 순", handler: { _ in print("유효기간 임박 순") })
//        let cancel = UIAction(title: "교환처 이름 순", attributes: .destructive, handler: { _ in print("교환처 이름 순") })
//        let buttonMenu = UIMenu(title: "유효기간 임박 순", children: [ok, cancel])
//        if #available(iOS 14.0, *) {
//            filterButton.menu = buttonMenu
//        } else {
//            print("14. 0 under")
//        }
        
        
        
        setupFlowLayout()
    }
    
    @IBAction func dropDownAction(_ sender: Any) {
        dropDown.show()
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
        flowLayout.itemSize = CGSize(width: halfWidth * 1 , height: halfWidth * 1 + 50)
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
        print("collectionItems.count ", expirationPeriodLabelArr.count)
        return expirationPeriodLabelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("indexPath... ", indexPath)
        print("collectionItems[indexPath.row]... ", expirationPeriodLabelArr[indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        //  Configure the Cell
        cell.brandNameLabel.text = barndNameLabelArr[indexPath.row]
        cell.productNameLabel.text = "\("뿌링클 순살 + 1.25L 콜라 + 치즈볼")"
        print("ddfkmweofmwlekmf ", Int(cell.productNameLabel.text!.count / 15) + 1)
        cell.expirationPeriodLabel.text = "유효기간 : \(expirationPeriodLabelArr[indexPath.row])"
//        cell.registrantLabel.text = "등록자 : \("ghdrlfehd@naver.com(신승욱)")"
//        cell.layer.borderWidth = 2.0
//        cell.layer.borderColor = UIColor.red.cgColor
        cell.cellImageView.image = UIImage(named: "saewookkang")
        
//        @IBOutlet weak var brandLabel: UILabel!
//        @IBOutlet weak var productNameLabel: UILabel!
//        @IBOutlet weak var expirationPeriodLabel: UILabel!
//        @IBOutlet weak var registrantLabel: UILabel!
//        @IBOutlet weak var cellImageView: UIImageView!
        
        return cell
    }
    
    
}
