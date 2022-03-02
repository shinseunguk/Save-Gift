//
//  CustomTabBarController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/05.
//

import Foundation
import UIKit
import JJFloatingActionButton

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    var index = 0
    var VC : String?
    // 뷰 전체 폭 길이
    let screenHeight = UIScreen.main.bounds.size.height
    //기기 가로길이 구하기
    let screenWidth = UIScreen.main.bounds.size.width
    
    let actionButton = JJFloatingActionButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        

        print("screenWidth : ", screenWidth)
        print("screenHeight : ", screenHeight)
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: screenWidth-78, height: 40))
        lbNavTitle.textColor = UIColor.black
        lbNavTitle.numberOfLines = 0
        lbNavTitle.center = CGPoint(x: 0, y: 0)
        lbNavTitle.textAlignment = .left
//        lbNavTitle.font = UIFont(name: "나눔손글씨 암스테르담", size: 24)
        lbNavTitle.font = UIFont(name: "나눔손글씨", size: 24)
        lbNavTitle.text = "기프티콘 저장"

        self.navigationItem.titleView = lbNavTitle
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor.red // 테스트중
        
        if(UserDefaults.standard.string(forKey: "ID") != nil){
            print(UserDefaults.standard.string(forKey: "ID")!,"#########")
        }
        
        print("VC ########### ", VC)
        
        if VC != nil {
            if VC! == "공유하기" {
                selectedIndex = 0
                lbNavTitle.text = "기프티콘 공유"
            } else if VC! == "선물하기"{
                selectedIndex = 1
                lbNavTitle.text = "기프티콘 선물"
            }
        }else{
            //세번째로 이동시킴
            selectedIndex = 2
        }
        
        floatingBtn()
    }
    
    @objc func plusAction() {
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "friendVC") as? FriendController else{ // 변경해야됨
            return
        }
        
            self.navigationController?.pushViewController(pushVC, animated: true)
        
//        let backBarButtonItem = UIBarButtonItem(title: "친구추가", style: .plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("customtabbar viewWillAppear")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        //네비게이션바 뒤로가기 삭제
        self.navigationItem.hidesBackButton = true
//
//        self.navigationController?.navigationBar.topItem?.title = "기프티콘 저장"
        
    }
    
}

extension CustomTabBarController{

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title! {
        case "공유하기":
            actionButton.isHidden = true
//            view.removeFromSuperview()
            
            self.navigationItem.rightBarButtonItem = nil
        if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
            navigationBarSetting(navigationTitle: "기프티콘 공유")
        } else{// 로그인 X
            needLoginService("공유하기")
        }
            
            self.navigationItem.rightBarButtonItem = nil
        case "선물하기":
            actionButton.isHidden = true
            if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
                navigationBarSetting(navigationTitle: "기프티콘 선물")
            } else{// 로그인 X
                needLoginService("선물하기")
            }
            
            self.navigationItem.rightBarButtonItem = nil
        case "저장소":
            actionButton.isHidden = false
        navigationBarSetting(navigationTitle: "기프티콘 저장")
            
            self.navigationItem.rightBarButtonItem = nil
        case "친구":
            actionButton.isHidden = true
            if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
                navigationBarSetting(navigationTitle: "친구")
            } else{// 로그인 X
                needLoginService("선물하기")
            }
            
            let rightBarButton = UIBarButtonItem.init(image: UIImage(systemName: "plus"),  style: .plain, target: self, action: #selector(self.plusAction)) //Class.MethodName
            self.navigationItem.rightBarButtonItem = rightBarButton
            
            navigationBarSetting(navigationTitle: "친구")
        case "환경설정":
            actionButton.isHidden = true
            navigationBarSetting(navigationTitle: "환경설정")
            
            self.navigationItem.rightBarButtonItem = nil
        default:
            self.navigationItem.leftBarButtonItem = nil
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return index != 1
    }
    
    func navigationBarSetting(navigationTitle : String){
        let screenWidth = UIScreen.main.bounds.size.width
        if(navigationTitle != "친구"){
            let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: screenWidth-78, height: 40))
            lbNavTitle.textColor = UIColor.black
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name: "나눔손글씨 무궁화", size: 28)
            lbNavTitle.text = navigationTitle

            self.navigationItem.titleView = lbNavTitle
        }else {
            let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: screenWidth-95, height: 40))
            lbNavTitle.textColor = UIColor.black
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name: "나눔손글씨 무궁화", size: 28)
            lbNavTitle.text = navigationTitle

            self.navigationItem.titleView = lbNavTitle
        }
//        lbNavTitle.backgroundColor = UIColor.white
    }
    
    func needLoginService(_ VC : String){
        let alert = UIAlertController(title: "로그인", message: "로그인이 필요한 서비스입니다. \n 로그인 화면으로 이동하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            //세번째로 이동시킴
            self.selectedIndex = 2
            self.navigationBarSetting(navigationTitle: "기프티콘 저장")
            self.navigationItem.rightBarButtonItem = nil
        })
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            self.selectedIndex = 2
            self.navigationBarSetting(navigationTitle: "기프티콘 저장")
            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "viewVC") as? ViewController else{
                return
            }
            
            pushVC.VC = VC
                    self.navigationController?.pushViewController(pushVC, animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "홈화면", style: .plain, target: self, action: nil)
            self.navigationItem.backBarButtonItem = backBarButtonItem
            self.navigationItem.rightBarButtonItem = nil
        })
        self.present(alert, animated: true, completion: nil)
        actionButton.isHidden = false
        
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
}
