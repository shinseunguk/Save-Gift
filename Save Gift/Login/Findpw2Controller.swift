//
//  Findpw2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/06/08.
//

import Foundation
import UIKit

class Findpw2Controller : UIViewController, UITextFieldDelegate{
    let LOG_TAG : String = "Findpw2Controller"
    let helper = Helper()
    let localUrl = "".getLocalURL()
    @IBOutlet weak var changePassWord: UITextField!
    @IBOutlet weak var changeRePassWord: UITextField!
    @IBOutlet weak var modifyBtn2: UIButton!
    
    let border1 = CALayer()
    let border2 = CALayer()
    
    var dic : Dictionary<String, Any> = [:]
    var userIdFromFindPw : String? = nil
    
    override func viewDidLoad(){
        setNavTitle()
        setupLayout()
        
        changePassWord.addLeftPadding()
        changeRePassWord.addLeftPadding()
        
        changePassWord.tag = 0
        changeRePassWord.tag = 1
        
        changePassWord.attributedPlaceholder = NSAttributedString(string: "비밀번호(영어, 숫자, 특수문자를 포함한 8 ~ 20자)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        changeRePassWord.attributedPlaceholder = NSAttributedString(string: "비밀번호 재확인", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        self.changePassWord.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.changeRePassWord.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        changePassWord.delegate = self
        changeRePassWord.delegate = self
        
        modifyBtn2.isEnabled = false
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
    
    func setupLayout(){
        modifyBtn2.layer.cornerRadius = 5
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            checkMaxLength(textField: changePassWord, maxLength: 20)
        }else if textField.tag == 1{
            checkMaxLength(textField: changeRePassWord, maxLength: 20)
        }
        if changePassWord.text?.count == 0 && changeRePassWord.text?.count == 0 {
            modifyBtn2.isEnabled = false
            modifyBtn2.backgroundColor = .systemGray2
        }else {
            modifyBtn2.isEnabled = true
            modifyBtn2.backgroundColor = .systemBlue
        }
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.tag == 0 {
            if (changePassWord.text?.count ?? 0 > maxLength) {
                changePassWord.deleteBackward()
            }
        }else if textField.tag == 1{
            if (changeRePassWord.text?.count ?? 0 > maxLength) {
                changeRePassWord.deleteBackward()
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        //DB체크후 화면이동
        print("nextAction")
        if !(changePassWord.text?.validatePassword(changePassWord.text!) ?? true) {
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "비밀번호를 확인해주세요. 비밀번호(영어, 숫자, 특수문자를 포함한 8 ~ 20자)", completeTitle: "확인", nil)
        }else if changePassWord.text != changeRePassWord.text {
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "비밀번호와 비밀번호 재확인이 일치하지 않습니다", completeTitle: "확인", nil)
        }else {
            dic["user_password"] = changePassWord.text!
            dic["user_id"] = userIdFromFindPw!
            passwordChangeRequest(requestUrl: "/useinfo/password", param : dic)
        }
    }
    
    func passwordChangeRequest(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
        let paramData = try! JSONSerialization.data(withJSONObject: param)
        // URL 객체 정의
                let url = URL(string: localUrl+requestUrl)
                
                // URLRequest 객체를 정의
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.httpBody = paramData
                
                // HTTP 메시지 헤더
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
//                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//                request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
                
                // URLSession 객체를 통해 전송, 응답값 처리
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버가 응답이 없거나 통신이 실패
                    if let e = error {
                        print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
                        return
                    }
                    
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

//                    print("회원가입 응답 처리 로직 responseString", responseString!)
//                    print("응답 처리 로직 data", data as Any)
//                    print("응답 처리 로직 response", response as Any)
                    // 응답 처리 로직
                    
                    DispatchQueue.main.async{
                        if responseString == "true" {
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "비밀번호가 재설정되었습니다", completeTitle: "확인", nil)
                            if let viewControllers = self.navigationController?.viewControllers {
                                    if viewControllers.count > 3 {
                                        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                                    }
                            }
                        }else {
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "회원정보 확인 실패", completeTitle: "확인", nil)
                        }
                    }
                        
                        
                }
            // POST 전송
            task.resume()
    }
}
