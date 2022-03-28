//
//  SettingMyInfo2Controller.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/19.
//

import Foundation
import UIKit

class SettingMyInfo2Controller : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingMyInfo2Controller viewDidLoad")
        
    }
    @IBAction func changeInfoAction(_ sender: Any) {
        //성공시 처리 2번 pop
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 3 {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            } else {
                        // fail
            }
        }
    }
}
