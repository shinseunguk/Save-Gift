//
//  GiftPresentPage2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/04/19.
//

import Foundation
import UIKit
import DropDown

class GiftPresentPage2Controller : UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let cellHeight3 = ((UIScreen.main.bounds.width / 2) + 50) / 3
    
    var index : Int = 0
    
    //기기 세로길이
    let screenHeight = UIScreen.main.bounds.size.height
    //기기 가로길이 구하기
    let screenWidth = UIScreen.main.bounds.size.width
    
    var viewPagerArr = ["Unused", "Used", "All"]
//    var barndNameLabelArr = ["Page1","BBQ","피자나라 치킨공주","교촌치킨","60계치킨","처갓집양념치킨","호식이두마리치킨","꾸브라꼬숯불두마리치킨"]
//    var expirationPeriodLabelArr = ["2022-04-14","2022-04-15","2022-04-16","2022-04-19","2022-04-20","2022-05-14","2022-02-14","2022-04-30"]
//    var productNameLabelArr = ["뿌링클 순살 + 1L 콜라 + 치즈볼", "뿌링클 순살 + 2L 콜라 + 치즈볼", "뿌링클 순살 + 3L 콜라 + 치즈볼" ,"뿌링클 순살 + 4L 콜라 + 치즈볼", "뿌링클 순살 + 5L 콜라 + 치즈볼", "뿌링클 순살 + 6L 콜라 + 치즈볼", "뿌링클 순살 + 7L 콜라 + 치즈볼", "뿌링클 순살 + 8L 콜라 + 치즈볼"]
//    var cellImageViewArr = ["chicken.jpg", "chicken.jpg", "chicken.jpg", "chicken.jpg", "chicken.jpg", "chicken.jpg", "chicken.jpg", "chicken.jpg"]
//    var seqArr = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    var thumbnail: Array<UIImage> = []
    
    // test Array
        var barndNameLabelArr : [String] = []
        var expirationPeriodLabelArr : [String] = []
        var productNameLabelArr : [String] = []
        var cellImageViewArr : [String] = []
    
    //cocoa pod
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if barndNameLabelArr.count == 0 &&  expirationPeriodLabelArr.count == 0{
            label.isHidden = false
            collectionView.isHidden = true
            filterButton.isHidden = true
        }else {
            label.isHidden = true
            collectionView.isHidden = false
            filterButton.isHidden = false
        }
        
//        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/save-gift-e3710.appspot.com/o/bhc.jpg?alt=media&token=54938b56-88bf-4a0f-acc4-98222e1412ac")!
////        if let data = try? Data(contentsOf: url) {
////        thumbnail[0] = UIImage(data: try! Data(contentsOf: url))!
////        thumbnail[1] = UIImage(data: try! Data(contentsOf: url))!
////        thumbnail[2] = UIImage(data: try! Data(contentsOf: url))!
////        thumbnail[3] = UIImage(data: try! Data(contentsOf: url))!
////        thumbnail[4] = UIImage(data: try! Data(contentsOf: url))!
////        thumbnail[5] = UIImage(data: try! Data(contentsOf: url))!
////        thumbnail[6] = UIImage(data: try! Data(contentsOf: url))!
////        thumbnail[7] = UIImage(data: try! Data(contentsOf: url))!
//
//        for x in 0...7 {
//            thumbnail.append(UIImage(data: try! Data(contentsOf: url))!)
//        }
        
        
        
        //드롭다운 btnInit
        dropDownInit()
        
        //컬렉션뷰 Init
        collectionViewInit()
        
        //setupFlowLayout
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //서버 통신후 사용자 혹은 로컬기기 -> DB에 저장되어 있는 값 가져오기
        setupInit()
        
        //서버통신후 getGifty
        getGifty()
    }
    
    func setupInit(){
        
    }
    
    
    func getGifty(){
        if barndNameLabelArr.count == 0 &&  expirationPeriodLabelArr.count == 0{
            print("선물 가능한 기프티콘에 기프티콘이 존재하지 않음.")
            label.isHidden = false
            collectionView.isHidden = true
            filterButton.isHidden = true
            
            // 화면 처음그릴때만 add subView
            print("index ", index)
            if index == 0 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 61))
                label.numberOfLines = 2
                label.font = UIFont(name: "NanumAmSeuTeReuDam", size: 24)
                label.textColor = .black
                label.center = self.view.center
                label.textAlignment = .center
//                label.text = "기프티콘을 추가해 \n 관리, 공유, 선물해보세요"
                    label.text = """
                    선물 가능한 기프티콘이 없습니다.
                    저장소에서 기프티콘을 추가해 선물 해보세요!
                    """
                
                self.view.addSubview(label)
                index += 1
            }
        }else {
            print("선물 가능한 기프티콘이 존재.")
            collectionView.isHidden = false
            filterButton.isHidden = false
            label.isHidden = true
        }
    }
    
    
    func collectionViewInit(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
//        collectionView.isScrollEnabled = false
    }
    
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        flowLayout.minimumInteritemSpacing = 0 // 좌우 margin
        flowLayout.minimumLineSpacing = 10 // 위아래 margin
        
        let halfWidth = UIScreen.main.bounds.width / 2
//        flowLayout.itemSize = CGSize(width: halfWidth * 0.9 , height: halfWidth * 0.9)
//        flowLayout.itemSize = CGSize(width: halfWidth * 1 , height: halfWidth * 1 + 50)
        flowLayout.itemSize = CGSize(width: halfWidth * 1 , height: halfWidth * 2)
        flowLayout.footerReferenceSize = CGSize(width: halfWidth * 3, height: 70)
        flowLayout.sectionFootersPinToVisibleBounds = true
//        flowLayout.sectionInset = UIEdgeInsets(top:5, left:15, bottom:5, right:7.5);
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func dropDownInit() {
        //드롭다운 btn
        dropDown.dataSource = ["최근 등록순","유효기간 임박순", "상품명순", "교환처 이름순"]
        dropDown.anchorView = filterButton
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        //드롭다운 선택
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
            self.dropDown.clearSelection()
            filterButton.setTitle(" "+item, for: .normal)

            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    @IBAction func dropDownAction(_ sender: Any) {
        dropDown.show()
    }
}

extension GiftPresentPage2Controller: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return expirationPeriodLabelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
            //  Configure the Cell
            cell.brandNameLabel.text = barndNameLabelArr[indexPath.row]
            cell.productNameLabel.text = productNameLabelArr[indexPath.row]
            cell.expirationPeriodLabel.text = "유효기간 : \(expirationPeriodLabelArr[indexPath.row])"
        
        
            cell.cellImageView.image = UIImage(named: cellImageViewArr[indexPath.row])
            cell.cellImageView.contentMode = .scaleAspectFit
//        cell.layer.borderWidth = 1.0
//        cell.layer.borderColor = UIColor.black.cgColor
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("collectionView didSelectItemAt.... ", indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        
        //click animate
        if let cell = collectionView.cellForItem(at: indexPath) {
               cell.backgroundColor = cell.isSelected ? .systemGray2 : .white
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
                cell.backgroundColor = UIColor.white
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GiftDetailVC") as! GiftDetailController
//                vc.modalPresentationStyle = .fullScreen
//                vc.definesPresentationContext = true
//                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}
    
