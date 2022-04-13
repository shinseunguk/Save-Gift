//
//  SettingMyInfo2Controller.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/19.
//

import Foundation
import UIKit

class SettingMyInfo2Controller : UIViewController{
    @IBOutlet weak var modifyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingMyInfo2Controller viewDidLoad")
        
        setupLayout()
    }
    
    func setupLayout(){
        modifyBtn.layer.cornerRadius = 5
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
