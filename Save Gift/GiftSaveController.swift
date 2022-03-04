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
import LocalAuthentication

class GiftSaveController : UIViewController {
    
    @IBOutlet weak var tabBar: UITabBarItem!
    // MARK: EffectView가 들어갈 View
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    let giftReigster : GiftRegisterController = GiftRegisterController()
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    let customTabBarC : CustomTabBarController = CustomTabBarController()
    
    // MARK: Blur효과가 적용될 EffectView
    var viewBlurEffect:UIVisualEffectView!
    let cellHeight3 = ((UIScreen.main.bounds.width / 2) + 50) / 3
    
    //기기 세로길이
    let screenHeight = UIScreen.main.bounds.size.height
    //기기 가로길이 구하기
    let screenWidth = UIScreen.main.bounds.size.width
    
    var barndNameLabelArr = ["BHC","BBQ","피자나라 치킨공주","교촌치킨","60계치킨","처갓집양념치킨","호식이두마리치킨","꾸브라꼬숯불두마리치킨"]
    var expirationPeriodLabelArr = ["2022-04-14","2022-04-15","2022-04-16","2022-04-19","2022-04-20","2022-05-14","2022-02-14","2022-04-30"]
    
    //cocoa pod
    let dropDown = DropDown()
    let actionButton = JJFloatingActionButton()
    
    var nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftSaveController viewDidLoad")
        print("cellWidth/3 : ", cellHeight3)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        //드롭다운 btn
        dropDown.dataSource = ["최근등록순", "등록일순", "유효기간 임박순", "상품명순", "교환처 이름순"]
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
        
        //collectionview layout
        setupFlowLayout()
        
        //blur효과
        btnBlurCreate()
        
        //가운데 lock btn
        lockBtn()
    }
    
    @IBAction func dropDownAction(_ sender: Any) {
        dropDown.show()
    }
    
    func floatingBtn(){
        actionButton.addItem(title: "바코드(기프티콘) 저장하기", image: UIImage(systemName: "barcode")?.withRenderingMode(.alwaysTemplate)) { item in
            print("바코드(기프티콘) 저장하기")
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GiftRegisterVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }

        actionButton.addItem(title: "QR코드 저장하기", image: UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            print("qrcode 2")
        }
        
//        actionButton.addItem(title: "item 3", image: nil) { item in
//          // do something
//        }
        
        view.addSubview(actionButton)
        actionButton.buttonColor = .systemBlue
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        actionButton.configureDefaultItem { item in
//            item.titlePosition = .trailing

            item.titleLabel.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
            item.titleLabel.textColor = .white
            item.buttonColor = .white
            item.buttonImageColor = .systemBlue

            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.4)
            item.layer.shadowRadius = CGFloat(2)
        }
        
                actionButton.bottomAnchor.constraint(equalTo: view.topAnchor
                            ,constant: screenHeight-200).isActive = true // ---- 1
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
    
    // MARK: 블루 추가 버튼
    func btnBlurCreate() {
        if viewBlurEffect == nil {
            viewBlurEffect = UIVisualEffectView()

            //Blur Effect는 .light 외에도 .dark, .regular 등이 있으니 적용해보세요!
            viewBlurEffect.effect = UIBlurEffect(style: .dark)
//            viewBlurEffect.effect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
            
            //viewMain에 Blur 효과가 적용된 EffectView 추가
            self.viewMain.addSubview(viewBlurEffect)
            viewBlurEffect.frame = self.viewMain.bounds
        }
    }
    // MARK: 블러 제거 버튼
    func btnBlurRemove() {
        if viewBlurEffect != nil {
            viewBlurEffect.removeFromSuperview()
            viewBlurEffect = nil
        }
    }
    
    func lockBtn() {
        self.view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
//        nextButton.setTitle("잠금해제", for: .normal)
        nextButton.backgroundColor = UIColor.black
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.tintColor = UIColor.white
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 15
//        nextButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        // 크기
//        nextButton.contentHorizontalAlignment = .fill
//        nextButton.contentVerticalAlignment = .fill
//        nextButton.imageView?.contentMode = .scaleAspectFill
//        nextButton.imageView?.contentMode = .scaleAspectFit
//        nextButton.imageView?.widthAnchor
        
        //set image
        nextButton.setImage(UIImage(systemName: "lock"), for: .normal)
        
        //imageview image size
        nextButton.setPreferredSymbolConfiguration(.init(pointSize: 35, weight: .regular, scale: .default), forImageIn: .normal)
        
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        nextButton.addTarget(self, action: #selector(unlockAction), for: .touchUpInside)
    }
    
    @objc
    func unlockAction() {
        // 생체인식 이후 적용해야함(두줄)
        auth()
    }
    
    func auth() {
        
        let authContext = LAContext()
        var error: NSError?
        var description: String!

//        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            print("authContext.biometryType ", authContext.biometryType)
            switch authContext.biometryType {
            case .faceID:
                description = "서비스를 이용하기 위해 인증 합니다."
                break
            case .touchID:
                description = "서비스를 이용하기 위해 인증 합니다."
                break
            case .none:
                description = "서비스를 이용하기 위해 인증 합니다."
                break
            default:
                print("default")
                break
            }
            
//            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { (success, error) in
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: description) { (success, error) in
                if success {
                    print("인증 성공")
                    DispatchQueue.main.async{
                        self.btnBlurRemove()
                        self.nextButton.removeFromSuperview()
                        self.floatingBtn()
                    }
                } else {
                    print("인증 실패")
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }

    }
}

}

extension GiftSaveController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("collectionItems.count ", expirationPeriodLabelArr.count)
        return expirationPeriodLabelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("indexPath... ", indexPath)
//        print("collectionItems[indexPath.row]... ", expirationPeriodLabelArr[indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        //  Configure the Cell
        cell.brandNameLabel.text = barndNameLabelArr[indexPath.row]
        cell.productNameLabel.text = "\("뿌링클 순살 + 1.25L 콜라 + 치즈볼")"
//        print("ddfkmweofmwlekmf ", Int(cell.productNameLabel.text!.count / 15) + 1)
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
