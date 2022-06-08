//
//  Findpw2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/06/08.
//

import Foundation
import UIKit

class Findpw2Controller : UIViewController{
    let LOG_TAG : String = "Findpw2Controller"
    let helper = Helper()
    let localUrl = "".getLocalURL()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var authBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var description1: UILabel!
    
    var nextBool : Bool = false
    
    let border1 = CALayer()
    let border2 = CALayer()
    
    var minute : Int = 0
    var second : Int = 0
    var dic : Dictionary<String, Any> = [:]
    var checkDic: Dictionary<String, Any> = [:]
    var topLabel: UILabel = {

        let topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 12)
        topLabel.textColor = .lightGray
        topLabel.backgroundColor = .white
        topLabel.numberOfLines = 1
        return topLabel

    }()
    
    override func viewDidLoad(){
        setNavTitle()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func setNavTitle(){
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "비밀번호 재설정"
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
//            if (nameTextField.text?.count ?? 0 > maxLength) {
//                nameTextField.deleteBackward()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        //DB체크후 화면이동
        print("nextAction")
    }
    
    @IBAction func authAction(_ sender: Any) {
    }
}
