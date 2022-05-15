//
//  CustomTabBarController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/05.
//

import Foundation
import UIKit
import JJFloatingActionButton

protocol customTabBarDelegate {
    func tabbarDelegate()
}

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    var index = 0
    var VC : String?
    // 뷰 전체 폭 길이
    let screenHeight = UIScreen.main.bounds.size.height
    //기기 가로길이 구하기
    let screenWidth = UIScreen.main.bounds.size.width
    
    let actionButton = JJFloatingActionButton()
    let appearance = UINavigationBarAppearance()
    
    @IBOutlet weak var uiTabBar: UITabBar!
    
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
            } else if VC! == "선물함"{
                selectedIndex = 1
                lbNavTitle.text = "선물함"
            } else if VC! == "친구"{ // 수정 필요
                selectedIndex = 2
                lbNavTitle.text = "기프티콘 저장"
            }
        }else{
            //세번째로 이동시킴
            selectedIndex = 2
        }
        
//        floatingBtn()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

//        uiTabBar.frame.size.height = 60
//        uiTabBar.frame.origin.y = 500
    }
    
    @objc func plusAction() {
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "friendVC") as? FriendController else{ // 변경해야됨
            return
        }
        
        pushVC.delegateC = self
        self.navigationController?.pushViewController(pushVC, animated: true)
        
//        let backBarButtonItem = UIBarButtonItem(title: "친구추가", style: .plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("customtabbar viewWillAppear")
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // 네비게이션바 become black 삭제
        appearance.shadowColor = .white // 네비게이션바 bottom 테두리 삭제
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        //네비게이션바 뒤로가기 삭제
        self.navigationItem.hidesBackButton = true
//
//        self.navigationController?.navigationBar.topItem?.title = "기프티콘 저장"
        
//        if #available(iOS 15.0, *) {
            let appearanceTabbar = UITabBarAppearance()
            appearanceTabbar.configureWithOpaqueBackground()
            appearanceTabbar.backgroundColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
            uiTabBar.standardAppearance = appearanceTabbar
//            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//        }
        uiTabBar.layer.borderWidth = 0.30
        uiTabBar.layer.borderColor = UIColor.clear.cgColor
        uiTabBar.clipsToBounds = true
        
        
    }
    
}

extension CustomTabBarController: customTabBarDelegate{
        
    func tabbarDelegate() {
        print("친구 화면으로 다시 이동. \(#line)")
        self.selectedIndex = 3
        self.selectedIndex = 3
        print("친구 화면으로 다시 이동. \(#line)")
        //되긴됨 refresh 해야함.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title! {
        case "공유하기":
//            actionButton.isHidden = true
//            view.removeFromSuperview()
            
            self.navigationItem.rightBarButtonItem = nil
        if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
            navigationBarSetting(navigationTitle: "기프티콘 공유")
        } else{// 로그인 X
            needLoginService("공유하기")
        }
            
            self.navigationItem.rightBarButtonItem = nil
        case "선물함":
//            actionButton.isHidden = true
            if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
                navigationBarSetting(navigationTitle: "선물함")
            } else{// 로그인 X
                needLoginService("선물함")
            }
            
            self.navigationItem.rightBarButtonItem = nil
        case "저장소":
//            actionButton.isHidden = false
        navigationBarSetting(navigationTitle: "기프티콘 저장")
            
            self.navigationItem.rightBarButtonItem = nil
        case "친구":
//            actionButton.isHidden = true
            if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
                navigationBarSetting(navigationTitle: "친구")
            } else{// 로그인 X
                needLoginService("친구")
            }
            
//            let rightBarButton = UIBarButtonItem.init(image: UIImage(systemName: "plus"),  style: .plain, target: self, action: #selector(self.plusAction)) //Class.MethodName
            let rightBarButton = UIBarButtonItem.init(title: "친구 추가", style: .plain, target: self, action: #selector(self.plusAction))
            self.navigationItem.rightBarButtonItem = rightBarButton
            
            navigationBarSetting(navigationTitle: "친구")
        case "환경설정":
//            actionButton.isHidden = true
            navigationBarSetting(navigationTitle: "환경설정")
            
            self.navigationItem.rightBarButtonItem = nil
        default:
            self.navigationItem.leftBarButtonItem = nil
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return index != 1
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("\(#line) tabBarController didSelect")
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
            let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: screenWidth-130, height: 40))
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
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
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
        
    }
}
