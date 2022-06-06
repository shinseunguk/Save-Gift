//
//  FindidController.swift
//  Save Gift
//  Created by ukBook on 2021/12/18.
//

import Foundation
import UIKit

class FindidController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("FindidController")
        
        setNavTitle()
    }
    
    func setNavTitle(){
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "아이디 / 비밀번호 찾기"
    }
}
