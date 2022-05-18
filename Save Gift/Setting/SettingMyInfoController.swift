//
//  SettingMyInfoController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/13.
//  내정보 아이디 + 비밀번호 확인 화면

import Foundation
import UIKit

class SettingMyInfoController : UIViewController {
    let LOG_TAG : String = "SettingMyInfoController"
    let helper : Helper = Helper()
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    let localUrl = "".getLocalURL();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("내정보 진입전 화면 SettingMyInfoController")
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "내정보 확인"
        confirmBtn.layer.cornerRadius = 5
        
        passWordTextField.addLeftPadding();
        passWordTextField.textAlignment = .left
        passWordTextField.textColor = UIColor.black
        passWordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
    }
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        requestPost(requestUrl : "/login")
    }
    
    func requestPost(requestUrl : String!) -> Void{
        let email = UserDefaults.standard.string(forKey: "ID")
        let password = passWordTextField.text
        let param = ["user_id" : email, "user_password" : password, "index" : "changeInfo"] as [String : Any] // JSON 객체로 전송할 딕셔너리
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
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크 에러", message: "네트워크 연결상태를 확인 해주세요", completeTitle: "확인", nil)
                        return
                    }
                    
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("회원가입 응답 처리 로직 responseString", responseString!)
//                    print("응답 처리 로직 data", data as Any)
//                    print("응답 처리 로직 response", response as Any)
                    // 응답 처리 로직
                    
                    if(responseString == "true"){
                        DispatchQueue.main.async{
                            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "SettingMyInfo2VC") as? SettingMyInfo2Controller else{
                                return
                            }
                                
                            self.navigationController?.pushViewController(pushVC, animated: true)
                        }
                    } else if(responseString == "false"){
                        DispatchQueue.main.async{
                        self.normalAlert(titles: "내정보 확인 실패", messages: "비밀번호를 확인해주세요.")
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
    func normalAlert(titles:String, messages:String?) -> Void{
        let alert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}
