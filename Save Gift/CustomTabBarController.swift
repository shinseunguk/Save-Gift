//
//  CustomTabBarController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/05.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        //기기 가로길이 구하기
        let screenWidth = UIScreen.main.bounds.size.width
        print("screenWidth : ", screenWidth)
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: screenWidth-78, height: 40))
//        lbNavTitle.backgroundColor = UIColor.white
        lbNavTitle.textColor = UIColor.black
        lbNavTitle.numberOfLines = 0
        lbNavTitle.center = CGPoint(x: 0, y: 0)
        lbNavTitle.textAlignment = .left
        lbNavTitle.font = UIFont(name: "나눔손글씨 무궁화", size: 28)
        lbNavTitle.text = "기프티콘 저장"

        self.navigationItem.titleView = lbNavTitle
        
        //세번째로 이동시킴
        selectedIndex = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        navigationBarSetting(navigationTitle: "기프티콘 공유")
        case "선물하기":
        navigationBarSetting(navigationTitle: "기프티콘 선물")
        case "저장소":
        navigationBarSetting(navigationTitle: "기프티콘 저장")
        case "랭킹보기":
        navigationBarSetting(navigationTitle: "기프티콘 랭킹")
        case "설정":
        navigationBarSetting(navigationTitle: "설정")
        default:
            self.navigationItem.leftBarButtonItem = nil
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return index != 1
    }
    
    func navigationBarSetting(navigationTitle : String){
        let screenWidth = UIScreen.main.bounds.size.width
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: screenWidth-78, height: 40))
//        lbNavTitle.backgroundColor = UIColor.white
        lbNavTitle.textColor = UIColor.black
        lbNavTitle.numberOfLines = 0
        lbNavTitle.center = CGPoint(x: 0, y: 0)
        lbNavTitle.textAlignment = .left
        lbNavTitle.font = UIFont(name: "나눔손글씨 무궁화", size: 28)
        lbNavTitle.text = navigationTitle

        self.navigationItem.titleView = lbNavTitle
    }
}
