//
//  MainController.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/19.
//  메인화면ㅋ

import Foundation
import UIKit

class MainController: UIViewController {
    // MARK: EffectView가 들어갈 View
    @IBOutlet var viewMain: UIView!
    
    // MARK: Blur효과가 적용될 EffectView
    var viewBlurEffect:UIVisualEffectView!
    
    var arrayString : [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
//        let rightBarButton = UIBarButtonItem.init(title: "확인", style: .plain, target: self, action: #selector(self.actionA)) //Class.MethodName
//        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "기프티콘 저장"
    }
    
    //    개발시에만 주석 ㅌㅅㅌ
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print("MainController viewWillAppear()")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("MainController viewWillDisappear()")
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func sideMenuOpen(_ sender: Any) {
        print("MainController sideMenuOpen")
    }
    
}
