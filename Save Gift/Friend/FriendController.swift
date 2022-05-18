//
//  FriendController.swift
//  Save Gift
//
//  Created by ukBook on 2022/02/27.
//  가입된 친구 검색

import Foundation
import UIKit
import JSPhoneFormat

class FriendController : UIViewController, UITextFieldDelegate {
    let LOG_TAG : String = "FriendController"
    @IBOutlet weak var magnifyingGlassButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var cellPhoneTextField: UITextField!
    @IBOutlet weak var findLabel: UILabel!
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var btnView: UIButton!
    
    var email : String?
    var cellPhone : String?
    var buttn : UIButton?
    
    let localUrl : String = "".getLocalURL()
    let phoneFormat = JSPhoneFormat.init(appenCharacter: "-")   //구분자로 사용하고싶은 캐릭터를 넣어주시면 됩니다.
    
    var dic : [String: Any] = [:];
    var emailName : String? = nil
    var delegateC : customTabBarDelegate?
        
    let helper : Helper = Helper();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellPhoneTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        //이메일 유효성검사(중복, 유효)
        
        // 휴대전화번호 placeholder
        emailTextfield.attributedPlaceholder = NSAttributedString(string: "이메일 형태로 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        cellPhoneTextField.keyboardType = .phonePad
        cellPhoneTextField.textAlignment = .left
        cellPhoneTextField.textColor = UIColor.black
        cellPhoneTextField.attributedPlaceholder = NSAttributedString(string: "숫자만 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        findBtn.layer.cornerRadius = 5
        
        btnView.isEnabled = false
        findBtn.isEnabled = false
        btnView.backgroundColor = UIColor.white
        findBtn.backgroundColor = UIColor.white
        findLabel.textColor = UIColor.white
        
        
        emailTextfield.delegate = self
        cellPhoneTextField.delegate = self
        
        
        
        
        
        //텍스트 필드 돋보기 표시
//        let magnifyingGlassButton = UIButton()
//        let image = UIImage(named: "ic_input_search_n")
//        magnifyingGlassButton.setBackgroundImage(image, forState: .Normal)
//        magnifyingGlassButton.frame = CGRectMake(0,0, 36, 36)
//        magnifyingGlassButton.addTarget(self, action: "magnifyingGlassButtonClick", forControlEvents: .TouchUpInside)
//        emailTextfield.rightView = magnifyingGlassButton
//        emailTextfield.rightViewMode = UITextFieldViewMode.Always
//
//
//        emailTextfield.delegate = self
            
        emailTextfield.addLeftPadding();
        cellPhoneTextField.addLeftPadding();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let text = textField.text
        
        if ((text?.contains("@")) != nil){
            emailSearch()
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkMaxLength(textField: cellPhoneTextField, maxLength: 13)
        guard let text = cellPhoneTextField.text else { return }
        cellPhoneTextField.text = phoneFormat.addCharacter(at: text)
    }   // phoneFormat.addCharacter에 텍스트를 넣어주면 init시 넣은 character가 구분자로 들어간 값이 반환됩니다.
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (cellPhoneTextField.text?.count ?? 0 > maxLength) {
            cellPhoneTextField.deleteBackward()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "가입된 친구 검색"
    }
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    func emailSearch() {
        email = emailTextfield.text
        
        if(email != ""){
            if !(email?.validateEmail(email!) ?? true) { // 정규식 false 일때
                // alert
                print("이메일 정규식 x")
                normalAlert(titles: "이메일로 찾기", messages: "정확한 이메일을 입력해주세요.")
            } else{
                // 서버 통신
                print("이메일 정규식 o")
                requestPost1(requestUrl: "/findemail")
            }
        } else{
            //alert
            print("빈칸검사 X")
            normalAlert(titles: "이메일로 찾기", messages: "이메일을 입력해주세요.")
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func emailSearchAction(_ sender: Any) {
        print("emailSearchAction")
        emailSearch()
    }
    
    @IBAction func phoneSearchAction(_ sender: Any) {
        print("phoneSearchAction")
        cellPhone = cellPhoneTextField.text
        
        if(cellPhone != ""){
            //서버통신
            print("휴대폰 번호 정규식 o")
            requestPost2(requestUrl: "/findphone")
        } else{
            //alert
            print("휴대폰 번호 정규식 x")
            normalAlert(titles: "휴대폰 번호로 찾기", messages: "휴대폰 번호를 입력해주세요.")
        }
        
        self.view.endEditing(true)
    }
    
    func normalAlert(titles:String, messages:String?) -> Void{
        let alert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertController.Style.alert)
        if messages != "친구 추가 완료" {
            let cancelAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(cancelAction)
        }else {
            let cancelAction = UIAlertAction(title: "확인", style: .default, handler : {_ in self.navPop()})
            alert.addAction(cancelAction)
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func navPop() -> Void{
        //nav pop
        //self.navigationController?.popViewController(animated: true)
//        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "tabbarVC") as? CustomTabBarController else{
//            return
//        }
//        pushVC.VC = "친구"
//
//        self.navigationController?.pushViewController(pushVC, animated: true)
        self.delegateC?.tabbarDelegate()
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestPost1(requestUrl : String!) -> Void{
        email = emailTextfield.text
        let param = ["user_id" : email] as [String : Any] // JSON 객체로 전송할 딕셔너리
        
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
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크 에러", message: "네트워크 연결상태를 확인 해주세요", completeTitle: "확인", nil)
                        return
                    }
                    
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("회원가입 응답 처리 로직 responseString", responseString!)
                    print("응답 처리 로직 data", data! as Any)
                    print("응답 처리 로직 response", response! as Any)
                    // 응답 처리 로직
                    
                    if responseString != "" && responseString != nil {
                        self.dic = self.helper.jsonParser(stringData: responseString as! String, data1: "user_id", data2: "name");
                        print("self.dic1 ", self.dic["user_id"]!)
                        print("self.dic2 ", self.dic["name"]!)
                    } else {
                        DispatchQueue.main.async{
                            self.normalAlert(titles: "이메일로 찾기", messages: "검색된 이메일이 없습니다.")
                        }
                    }
                    
                    if(responseString != ""){
                        DispatchQueue.main.async{
                            //view 추가
                            self.btnView.backgroundColor = UIColor.init(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
                            self.findLabel.textColor = UIColor.black
                            self.findLabel.text = self.dic["user_id"] as! String+"(\(self.dic["name"]!))"
                            
                            
                            if UserDefaults.standard.string(forKey: "ID") == self.dic["user_id"] as! String {
//                                self.findLabel.text = "본인은 친구추가 불가"
                                self.findBtn.setTitle("본인은 친구추가 불가", for: .normal)
                                self.findBtn.isEnabled = false
                                self.findBtn.backgroundColor = UIColor.systemGray2
                            } else {
                                self.requestStatusFriend(requestUrl : "/statusFriend");
                                    // 본인이 이미 추가한 사용자
                                    // 친구추가 거부한 사용자(기능 추가 예정)
                                    // 친구수락 대기중인 사용자
                            }
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
    func requestPost2(requestUrl : String!) -> Void{
        cellPhone = cellPhoneTextField.text
        let param = ["phone_number" : cellPhone] as [String : Any] // JSON 객체로 전송할 딕셔너리
        
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
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크 에러", message: "네트워크 연결상태를 확인 해주세요", completeTitle: "확인", nil)
                        return
                    }
                    
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("회원가입 응답 처리 로직 responseString", responseString)
                    print("응답 처리 로직 data", data! as Any)
                    print("응답 처리 로직 response", response! as Any)
                    // 응답 처리 로직
                    
                    if responseString != "" && responseString != nil {
                        self.dic = self.helper.jsonParser(stringData: responseString as! String, data1: "user_id", data2: "name");
                        print("self.dic1 ", self.dic["user_id"]!)
                        print("self.dic2 ", self.dic["name"]!)
                    } else {
                        DispatchQueue.main.async{
                            self.normalAlert(titles: "휴대폰 번호로 찾기", messages: "검색된 휴대폰 번호가 없습니다.")
                        }
                    }
                    
                    if(responseString != ""){
                        DispatchQueue.main.async{
                            //view 추가
                            
                            self.btnView.backgroundColor = UIColor.init(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
                            self.findLabel.textColor = UIColor.black
                            
                            self.findLabel.text = self.dic["user_id"] as! String+"(\(self.dic["name"]!))"
                            
                            self.requestStatusFriend(requestUrl : "/statusFriend");
                            
                            if UserDefaults.standard.string(forKey: "ID") == self.dic["user_id"] as! String {
//                                self.findLabel.text = "본인은 친구추가 불가"
                                self.findBtn.setTitle("본인은 친구추가 불가", for: .normal)
                                self.findBtn.isEnabled = false
                                self.findBtn.backgroundColor = UIColor.systemGray2
                            } else {
                                self.requestStatusFriend(requestUrl : "/statusFriend");
                                    // 본인이 이미 추가한 사용자
                                    // 친구추가 거부한 사용자(기능 추가 예정)
                                    // 친구수락 대기중인 사용자
                            }
                            
                        }
                    }
                    
                }
                // POST 전송
                task.resume()
    }
    
    @IBAction func addFriend(_ sender: Any) {
        if findBtn.isEnabled {
            print("친구 추가")
//            requestAddFriend(requestUrl: "/addFriend")
            requestWaitFriend(requestUrl: "/waitFriend") // url 변경해야함
        }
    }
    
    func requestStatusFriend(requestUrl : String!) -> Void{
        emailName = findLabel.text
        let param = ["user_id" : UserDefaults.standard.string(forKey: "ID"), "userIdName" : emailName] as [String : Any] // JSON 객체로 전송할 딕셔너리

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
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크 에러", message: "네트워크 연결상태를 확인 해주세요", completeTitle: "확인", nil)
                        return
                    }
                    
                    let str = String(data:data!, encoding:.utf8)
                    print("str ", str)

                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("회원가입 응답 처리 로직 responseString", responseString)
                    print("응답 처리 로직 data", data! as Any)
                    print("응답 처리 로직 response", response! as Any)
                    // 응답 처리 로직


                    if(responseString != ""){
                        DispatchQueue.main.async{
                            self.findLabel.text = self.emailName
                            if responseString! == "add friend"{ // 서버쪽 수정 필요
                                print("친구 추가")
                                self.findBtn.isEnabled = true
                                self.findBtn.backgroundColor = UIColor.systemBlue
                                self.findBtn.setTitle("친구 추가" as String, for: .normal)
                            } else if responseString! == "already friend"{
                                self.findBtn.isEnabled = false
                                self.findBtn.backgroundColor = UIColor.systemGray2
                                self.findBtn.setTitle("이미 친구인 사용자입니다" as String, for: .normal)
                            } else if responseString! == "wait friend"{
                                self.findBtn.isEnabled = false
                                self.findBtn.backgroundColor = UIColor.systemGray2
                                self.findBtn.setTitle("친구수락 대기중인 사용자입니다" as String, for: .normal)
                            }
                        }
                    }

                }
                // POST 전송
                task.resume()
    }
    
    
        func requestWaitFriend(requestUrl : String!) -> Void{
            emailName = findLabel.text
            let param = ["user_id" : UserDefaults.standard.string(forKey: "ID"), "userIdName" : emailName] as [String : Any] // JSON 객체로 전송할 딕셔너리
    
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
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크 에러", message: "네트워크 연결상태를 확인 해주세요", completeTitle: "확인", nil)
                            return
                        }
    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
    
                        print("/waitFriend ----> ", responseString!)
                        print("응답 처리 로직 data", data! as Any)
                        print("응답 처리 로직 response", response! as Any)
                        // 응답 처리 로직
    
    
                            if responseString! == "1" {
                            DispatchQueue.main.async{
                                //view 추가
                                print("responseString! == 1")
                                self.findBtn.isEnabled = false
                                self.findBtn.backgroundColor = UIColor.systemGray2
                                self.findBtn.setTitle("친구 추가 완료", for: .normal)
                                
                                self.normalAlert(titles: "알림", messages: "친구 추가 완료")
                                }
                            }else {
                                print("responseString! != 1")
                                self.findBtn.isEnabled = false
                                self.findBtn.backgroundColor = UIColor.systemGray2
                                self.findBtn.setTitle("친구 추가 실패", for: .normal)
                            }
    
                    }
                    // POST 전송
                    task.resume()
        }
    
//    func requestAddFriend(requestUrl : String!) -> Void{
//        emailName = findLabel.text
//        let param = ["user_id" : UserDefaults.standard.string(forKey: "ID"), "userIdName" : emailName] as [String : Any] // JSON 객체로 전송할 딕셔너리
//
//        let paramData = try! JSONSerialization.data(withJSONObject: param)
//        // URL 객체 정의
//                let url = URL(string: localUrl+requestUrl)
//
//                // URLRequest 객체를 정의
//                var request = URLRequest(url: url!)
//                request.httpMethod = "POST"
//                request.httpBody = paramData
//
//                // HTTP 메시지 헤더
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.addValue("application/json", forHTTPHeaderField: "Accept")
////                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
////                request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
//
//                // URLSession 객체를 통해 전송, 응답값 처리
//                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                    // 서버가 응답이 없거나 통신이 실패
//                    if let e = error {
//                        print("An error has occured: \(e.localizedDescription)")
//                        return
//                    }
//
//                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//
//                    print("회원가입 응답 처리 로직 responseString", responseString)
//                    print("응답 처리 로직 data", data! as Any)
//                    print("응답 처리 로직 response", response! as Any)
//                    // 응답 처리 로직
//
//
////                    if(responseString != ""){
////                        DispatchQueue.main.async{
////                            //view 추가
////                            self.btnView.isEnabled = true
////                            self.findBtn.isEnabled = true
////                            self.btnView.backgroundColor = UIColor.init(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
////                            self.findBtn.backgroundColor = UIColor.systemBlue
////                            self.findLabel.textColor = UIColor.black
////                            self.findBtn.backgroundColor = UIColor.systemBlue
////
////                            self.findLabel.text = self.dic["user_id"] as! String+"(\(self.dic["name"]!))"
////
////                            if UserDefaults.standard.string(forKey: "ID") == self.dic["user_id"] as! String {
////                                self.findLabel.text = "본인은 친구추가 불가"
////                                self.findBtn.setTitle("친구추가 불가", for: .normal)
////                                self.findBtn.isEnabled = false
////                                self.findBtn.backgroundColor = UIColor.systemGray2
////                            }
////
////                        }
////                    }
//
//                }
//                // POST 전송
//                task.resume()
//    }
}
