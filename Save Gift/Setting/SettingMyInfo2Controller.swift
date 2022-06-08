//
//  SettingMyInfo2Controller.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/19.
//

import Foundation
import UIKit

class SettingMyInfo2Controller : UIViewController, UITextFieldDelegate{
    let LOG_TAG = "SettingMyInfo2Controller"
    let localUrl = "".getLocalURL();
    let helper = Helper()
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var joinLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var changePassWord: UITextField!
    @IBOutlet weak var changeRePassWord: UITextField!
    @IBOutlet weak var modifyBtn1: UIButton!
    @IBOutlet weak var modifyBtn2: UIButton!
    
    var dic : Dictionary<String, Any> = [:]
    var create_date : String? = nil
    var password : String? = nil
    
    let user_id = UserDefaults.standard.string(forKey: "ID")
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingMyInfo2Controller viewDidLoad")
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "내정보 변경"
        
        setupLayout()
        Init()
        
        nameTextField.tag = 0
        changePassWord.tag = 1
        changeRePassWord.tag = 2
        
        nameTextField.addLeftPadding()
        changePassWord.addLeftPadding()
        changeRePassWord.addLeftPadding()
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        changePassWord.attributedPlaceholder = NSAttributedString(string: "비밀번호(영어, 숫자, 특수문자를 포함한 8자리 이상)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        changeRePassWord.attributedPlaceholder = NSAttributedString(string: "비밀번호 재확인", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        self.nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.changePassWord.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.changeRePassWord.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        nameTextField.delegate = self
        changePassWord.delegate = self
        changeRePassWord.delegate = self
        
        modifyBtn2.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 0:
            self.normalAlertYN(title: "알림", message: "앱내 해당아이디로 이용중인 기프티콘들과 회원정보를 변경하시겠습니까?", str: nameTextField.text!)
            break
        case 1:
            changeRePassWord.becomeFirstResponder()
            break
        case 2:
            password = changePassWord.text
            if changePassWord.text != changeRePassWord.text{
                helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "변경할 비밀번호와 재확인 비밀번호가 다릅니다.", completeTitle: "확인", nil)
            }else if !(password?.validatePassword(password!) ?? true) {
                helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "비밀번호를 확인해주세요. 비밀번호(영어, 숫자, 특수문자를 포함한 8자리 이상)", completeTitle: "확인", nil)
                changePassWord.becomeFirstResponder()
            }else {
                normalAlertYN(title: "알림", message: "해당 아이디의 비밀번호를 변경하시겠습니까?", str: password!)
            }
            break
        default:
            print("default")
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            checkMaxLength(textField: nameTextField, maxLength: 13)
        }else if textField.tag == 1 {
            checkMaxLength(textField: changePassWord, maxLength: 20)
        }else if textField.tag == 2 {
            checkMaxLength(textField: changeRePassWord, maxLength: 20)
        }
        
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.tag == 0 {
            if (nameTextField.text?.count ?? 0 > maxLength) {
                nameTextField.deleteBackward()
            }
        }else if textField.tag == 1 {
            if (changePassWord.text?.count ?? 0 > maxLength) {
                changePassWord.deleteBackward()
            }
        }else if textField.tag == 2 {
            if (changeRePassWord.text?.count ?? 0 > maxLength) {
                changeRePassWord.deleteBackward()
            }
        }
        
        if nameTextField.text?.count != 0 {
            modifyBtn1.isEnabled = true
            modifyBtn1.backgroundColor = .systemBlue
        }else {
            modifyBtn1.isEnabled = false
            modifyBtn1.backgroundColor = .systemGray2
        }
        
        if changePassWord.text?.count != 0 && changeRePassWord.text?.count != 0 {
            modifyBtn2.isEnabled = true
            modifyBtn2.backgroundColor = .systemBlue
        }else {
            modifyBtn2.isEnabled = false
            modifyBtn2.backgroundColor = .systemGray2
        }
        
    }
    
    func setupLayout(){
        modifyBtn1.layer.cornerRadius = 5
        modifyBtn2.layer.cornerRadius = 5
    }
    
    func Init(){
        idLabel.text = user_id
        initRequest(requestUrl: "/userinfo")
    }
    
    func setCreateDate(cDate : String){
        let year = cDate.substring(from: 0, to: 3)
        let month = cDate.substring(from: 5, to: 6)
        let day = cDate.substring(from: 8, to: 9)
        print("\(year) \(month) \(day)")
        joinLabel.text = "가입년월일  -  \(year)년 \(month)월 \(day)일"
    }
    
    @IBAction func changeNameAction(_ sender: Any) {
        print("\(#function)")
        normalAlertYN(title: "알림", message: "앱내 해당아이디로 이용중인 기프티콘들과 회원정보를 변경하시겠습니까?", str: nameTextField.text!)
    }
    
    @IBAction func changeInfoAction(_ sender: Any) {
//        @IBOutlet weak var changePassWord: UITextField!
//        @IBOutlet weak var changeRePassWord: UITextField!
        password = changePassWord.text
        if changePassWord.text != changeRePassWord.text{
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "변경할 비밀번호와 재확인 비밀번호가 다릅니다.", completeTitle: "확인", nil)
        }else if !(password?.validatePassword(password!) ?? true) {
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "비밀번호를 확인해주세요. 비밀번호(영어, 숫자, 특수문자를 포함한 8자리 이상)", completeTitle: "확인", nil)
            changePassWord.becomeFirstResponder()
        }else {
            normalAlertYN(title: "알림", message: "해당 아이디의 비밀번호를 변경하시겠습니까?", str: password!)
        }
        
        
        //성공시 처리 2번 pop
//        if let viewControllers = self.navigationController?.viewControllers {
//            if viewControllers.count > 3 {
//                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
//            } else {
//                        // fail
//            }
//        }
    }
    
    func normalAlertYN(title: String, message: String, str: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            if message == "앱내 해당아이디로 이용중인 기프티콘들과 회원정보를 변경하시겠습니까?"{
                let defaultAction = UIAlertAction(title: "변경", style: .default, handler : {_ in self.nameChangeRequest(requestUrl: "/userinfo/name", name: str)})
                alert.addAction(defaultAction)
            }else if message == "해당 아이디의 비밀번호를 변경하시겠습니까?" {
                let defaultAction = UIAlertAction(title: "변경", style: .default, handler : {_ in self.passwordChangeRequest(requestUrl: "/useinfo/password", password: str)})
                alert.addAction(defaultAction)
            }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler : nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func passwordChangeRequest(requestUrl : String!, password : String!) -> Void{
        let param = ["user_id" : user_id, "user_password" : password!] as [String : Any] // JSON 객체로 전송할 딕셔너리
//        let param = "user_Id=\(email)&name=\(name)"
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
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "비밀번호가 변경되었습니다.", completeTitle: "확인", nil)
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
    
    func nameChangeRequest(requestUrl : String!, name : String!) -> Void{
        let param = ["user_id" : user_id, "name" : name] as [String : Any] // JSON 객체로 전송할 딕셔너리
//        let param = "user_Id=\(email)&name=\(name)"
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
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "회원정보가 변경되었습니다.", completeTitle: "확인", nil)
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
    
    func initRequest(requestUrl : String!) -> Void{
        let param = ["user_id" : user_id] as [String : Any] // JSON 객체로 전송할 딕셔너리
//        let param = "user_Id=\(email)&name=\(name)"
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
                        if responseString != "" {
//                            print(responseString!)
                            self.dic = self.helper.jsonParser(stringData: responseString as! String, data1: "name", data2: "create_date");
                            print("dic ==> \n", self.dic)
                            self.nameTextField.text = self.dic["name"] as! String
                            self.setCreateDate(cDate: self.dic["create_date"] as! String)
                        }else {
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "회원정보 확인 실패", completeTitle: "확인", nil)
                        }
                    }
                        
                        
                }
            // POST 전송
            task.resume()
        }
}
