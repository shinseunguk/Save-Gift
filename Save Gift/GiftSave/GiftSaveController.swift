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
        
        //blur효과
        btnBlurCreate()
        
        //가운데 lock btn
        lockBtn()
        
        if UserDefaults.standard.bool(forKey: "lock"){ //한번이라도 푼적 있음.
            self.btnBlurRemove()
            self.nextButton.removeFromSuperview()
            self.floatingBtn()
        }else {
            let type = self.getBiometryType()
            if type == .faceId {
                nextButton.setImage(UIImage(systemName: "faceid"), for: .normal)
            } else if type == .touchId {
                nextButton.setImage(UIImage(systemName: "touchid"), for: .normal)
            } else {
                self.btnBlurRemove()
                self.nextButton.removeFromSuperview()
                self.floatingBtn()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("GiftSave viewWillAppear")
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
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GiftRegisterVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
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
    
    // MARK: 블러 추가 버튼
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
//        nextButton.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        
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
    
    // 얼굴이 인식되지 않음
    // 다시 시도
    // Face ID를 다시 시도하십시오.
    // 취소
    // Face ID 시도 횟수 초과됨
    // Face ID를 사용할 수 없습니다.
    func auth() {
        
        var error: NSError?
        var description: String!
        
        var authCount : Int = 0
//        authContext.localizedCancelTitle = "취소"
//        self.btnBlurRemove()
//        self.nextButton.removeFromSuperview()
//        self.floatingBtn()
        
//        let type = self.getBiometryType()
//        if type == .faceId {
//            nextButton.setImage(UIImage(systemName: "faceid"), for: .normal)
//        } else if type == .touchId {
//            nextButton.setImage(UIImage(systemName: "touchid"), for: .normal)
//        } else {
//            self.btnBlurRemove()
//            self.nextButton.removeFromSuperview()
//            self.floatingBtn()
//        }
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "서비스를 이용하기 위해 인증 합니다.") { (success, error) in
            print("인증결과", success, error)
            //Face ID 시도 횟수가 초과됨 \n Face ID를 사용할 수 없습니다.
            //스마트폰 Face ID가 잠겨있습니다. 잠금해제 후 다시 시도 해주세요.
            //스마트폰에 Face ID가 등록되어 있지 않습니다. Face ID 등록 후 다시 시도해주시기 바랍니다.
            
            
            if success {
                DispatchQueue.main.async{
                    self.btnBlurRemove()
                    self.nextButton.removeFromSuperview()
                    self.floatingBtn()
                    
                    UserDefaults.standard.set(true, forKey: "lock")
                }
            }else {
                switch error! {
                // 시스템(운영체제)에 의해 인증 과정이 종료 LAError.systemCancel:
                case LAError.systemCancel:
                    self.notifyUser(msg: "시스템에 의해 중단되었습니다.", err: error?.localizedDescription)
                // 사용자가 취소함 LAError.userCancel
                case LAError.userCancel:
                    self.notifyUser(msg: "인증이 취소 되었습니다.", err: error?.localizedDescription)
                // 터치아이디 대신 암호 입력 버튼을 누른경우(터치아이디 1회 틀리면 암호 입력 버튼 나옴) LAError.userFallback
                case LAError.userFallback:
                    self.notifyUser(msg: "터치 아이디 인증", err: "암호 입력을 선택했습니다.")
                default:
                    self.notifyUser(msg: "인증 실패", err: error?.localizedDescription)
                }
            }
        }
    }else {
        // 터치 아이디 사용할 수 없음
        switch error! {
        // 터치 아이디로 등록한 지문이 없다.
        case LAError.biometryNotEnrolled:
            self.notifyUser(msg: "터치아이디 지문이 없습니다.", err: error?.localizedDescription)
        // 디바이스의 패스코드를 설정 하지 않았다.
        case LAError.passcodeNotSet:
            self.notifyUser(msg: "설정된 패스코드가 없습니다.", err: error?.localizedDescription)
        default:
            self.notifyUser(msg: "터치아이디를 사용할 수 없습니다.", err: error?.localizedDescription)
        }
    }
        

        
    }
    
    func canEvaluatePolicy() -> Bool {
        let can = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return can
    }

    
    func getBiometryType() -> BiometryType {
        switch authContext.biometryType {
            case .faceID:
                return .faceId
            case .touchID:
                return .touchId
            default:
                return .none
        }
        
    }
    
    func notifyUser(msg: String, err: String?) {
        DispatchQueue.main.async{
            let alert =  UIAlertController(title: msg, message: err, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension GiftSaveController: PageboyViewControllerDataSource, TMBarDataSource{
    
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
