//
//  SettingSecessionController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/13.
//

import Foundation
import UIKit

class SettingSecessionController : UIViewController {
    @IBOutlet weak var secessionBtn: UIButton!
    let localUrl : String = "".getLocalURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "회원탈퇴"
        
        setupLayout()
    }
    
    func setupLayout(){
        secessionBtn.layer.cornerRadius = 5
    }
    
    @IBAction func secessionAction(_ sender: Any) {
        normalAlert(title: "알림", message: "정말로 회원 탈퇴하시겠습니까?")
    }
    
    func normalAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "확인", style: .destructive, handler :  {_ in self.secession()})
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler :  nil)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func normalAlertOne(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if message == "회원탈퇴 완료"{
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler :  {_ in self.secessionSuccess()})
            alert.addAction(defaultAction)
        }else{
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler :  {_ in self.secession()})
            alert.addAction(defaultAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func secession(){
        print("회원탈퇴")
        requestPost(requestUrl: "/secession")
    }
    
    func secessionSuccess(){
        UserDefaults.standard.removeObject(forKey: "ID")
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
        self.navigationController?.pushViewController(pushVC!, animated: true)
        print("화면 이동")
    }
    
    func requestPost(requestUrl : String!) -> Void{
        let param = ["user_id" : UserDefaults.standard.string(forKey: "ID")] as [String : Any] // JSON 객체로 전송할 딕셔너리
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
                        print("An error has occured: \(e.localizedDescription)")
                        return
                    }
                    
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("회원가입 응답 처리 로직 responseString", responseString!)
//                    print("응답 처리 로직 data", data as Any)
//                    print("응답 처리 로직 response", response as Any)
                    // 응답 처리 로직
                    if(responseString == "true"){
                        DispatchQueue.main.async{
                            self.normalAlertOne(title: "알림", message: "회원탈퇴 완료")
                        }
                    }else{
                        self.normalAlertOne(title: "알림", message: "회원가입 오류")
                    }
                }
                // POST 전송
                task.resume()
    }
}
