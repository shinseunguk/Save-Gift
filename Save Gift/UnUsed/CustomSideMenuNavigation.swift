//
//  CustomSideMenuNavigation.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/19.
//

import UIKit
import SideMenu

extension CustomSideMenuNavigation: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}

class CustomSideMenuNavigation: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentationStyle = .menuSlideIn
        //80프로
        self.menuWidth = self.view.frame.width * 0.7
        //왼쪽에서 나오기
        self.leftSide = true
        
        //보여지는 속도
//        self.presentDuration = 1.0
        //사라지는 속도
//        self.dismissDuration = 1.0
        
        // 사이드메뉴 닫기
//        dismiss(animated: true, completion: nil)
    }
    
}
