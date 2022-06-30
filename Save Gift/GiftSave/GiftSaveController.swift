//
//  GiftHowToUse.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 사용법

// 생체인증
// https://m.blog.naver.com/go4693/221208533076

// TabMan
// https://developer-p.tistory.com/161

// ios to server send image
// https://eastroot1590.tistory.com/entry/IOS-Training-%EC%84%9C%EB%B2%84%EC%97%90-%EC%A0%80%EC%9E%A5%EB%90%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80%EB%A1%9C-view-update

import Foundation
import UIKit
import JJFloatingActionButton
import DropDown
import LocalAuthentication
import Protobuf
import Tabman
import Pageboy

protocol uploadDelegate {
    func uploadGift()
}

class GiftSaveController : TabmanViewController{
    
    let helper : Helper = Helper()
    
    private var viewControllers: Array<UIViewController> = []
    
    @IBOutlet weak var tempView: UIView! // 상단 탭바 들어갈 자리
    
    @IBOutlet weak var countZeroLabel: UILabel!
    // MARK: EffectView가 들어갈 View
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var viewPager: UIView!
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: Blur효과가 적용될 EffectView
    var viewBlurEffect:UIVisualEffectView!
    let cellHeight3 = ((UIScreen.main.bounds.width / 2) + 50) / 3
    
    //기기 세로길이
    let screenHeight = UIScreen.main.bounds.size.height
    //기기 가로길이 구하기
    let screenWidth = UIScreen.main.bounds.size.width
    
//    var viewPagerArr = ["미사용+사용 기프티콘", "미사용 기프티콘", "사용 기프티콘"]
    var viewPagerArr = ["Unused", "Used", "All"]
    
    //cocoa pod
    let dropDown = DropDown()
    let actionButton = JJFloatingActionButton()
    let authContext = LAContext()
    var nextButton = UIButton()
    
    enum BiometryType {
        case faceId
        case touchId
        case none
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("lock --> ", UserDefaults.standard.bool(forKey: "lock"))
        
        print("GiftSaveController viewDidLoad")
        print("cellWidth/3 : ", cellHeight3)
        
        print("helper.formatDateTime() ", helper.formatDateTime())
        
        //tabbar setting(TabMan)
        setTabMan()
        
        //floating Button
        floatingBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("GiftSave viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool){
        print("viewDidAppear()")
    }
    
    func setTabMan() {
        let AllVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllVC") as! Page1Controller
        let UnusedVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UnusedVC") as! Page2Controller
        let UsedVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UsedVC") as! Page3Controller
                    
        viewControllers.append(AllVC)
        viewControllers.append(UnusedVC)
        viewControllers.append(UsedVC)
        
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
//        let bar = TMBar.TabBar()
        bar.backgroundView.style = .blur(style: .regular)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        bar.buttons.customize { (button) in
            button.tintColor = UIColor.systemGray2 // 선택 안되어 있을 때
            button.selectedTintColor = .systemBlue // 선택 되어 있을 때
            button.font = UIFont.systemFont(ofSize: 13)
        }
        // 인디케이터 조정
        bar.indicator.weight = .light
        bar.indicator.tintColor = .systemBlue
        bar.indicator.overscrollBehavior = .compress
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20 // 버튼 사이 간격
    
        bar.layout.transitionStyle = .snap // Customize

        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: tempView, layout: nil)) // .custom을 통해 원하는 뷰에 삽입함. BarLocatio https://github.com/uias/Tabman/blob/main/Sources/Tabman/TabmanViewController.swift#L27-L32
    }
    
    
    @IBAction func dropDownAction(_ sender: Any) {
        dropDown.show()
    }
    
    func floatingBtn(){
        actionButton.addItem(title: "바코드(기프티콘) 저장하기", image: UIImage(systemName: "barcode")?.withRenderingMode(.alwaysTemplate)) { item in
            print("바코드(기프티콘) 저장하기")
//            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GiftRegisterVC")
            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "GiftRegisterVC") as? GiftRegisterController else{
                return
            }
            pushVC.uploadDelegate = self
            self.navigationController?.pushViewController(pushVC, animated: true)
    }

        actionButton.addItem(title: "QR코드 저장하기", image: UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            print("qrcode 2")
        }
        
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
    
    func goSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}

extension GiftSaveController: PageboyViewControllerDataSource, TMBarDataSource, uploadDelegate{
    func uploadGift() {
        print("바코드 저장(GiftSave) -> 기프티콘 등록(GiftRegister) -> GiftSave reloadData")
        super.reloadData()
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
            // MARK: - Tab 안 글씨들
            switch index {
            case 0:
                return TMBarItem(title: viewPagerArr[0])
            case 1:
                return TMBarItem(title: viewPagerArr[1])
            case 2:
                return TMBarItem(title: viewPagerArr[2])
            default:
                let title = "Page \(index)"
                return TMBarItem(title: title)
            }

        }
        
        func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
            return viewPagerArr.count
        }
        
        func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
            return viewControllers[index]
        }
        
        func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
            return nil
        }
    
}
