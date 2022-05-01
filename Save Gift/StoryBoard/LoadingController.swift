//
//  LoadingController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/02.
//

import Foundation
import UIKit

class LoadingController : UIViewController {
    let LOG_TAG : String = "LoadingController"
    @IBOutlet weak var logo: UIImageView!
    
    let localUrl : String = "".getLocalURL()
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    let deviceModel = GetDeviceModel.deviceModelName()
    
    var pushToken : String = "test"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "barcodeLogo")
        
        //DB insert 하는 부분 구현
        print("device model : ", deviceModel)
        
        // 아이디저장
        UserDefaults.standard.set(deviceID, forKey: "device_id")
        
        // user_device DB insert
        requestPost(requestUrl: "/device/insert")
        
        requestNotificationPermission()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            navigationController?.setNavigationBarHidden(true, animated: animated)
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func requestNotificationPermission(){
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
                if didAllow {
                    print("Push: 권한 허용")
                } else {
                    print("Push: 권한 거부")
                }
            })
        }
    
    func requestPost(requestUrl : String!) -> Void{
        let param = ["device_model" : deviceModel, "device_id" : deviceID, "push_token" : pushToken, "push_yn" : 1 ,"push30" : 1, "push7" : 1 ,"push1" : 1] as [String : Any] // JSON 객체로 전송할 딕셔너리
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
//                        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "viewVC")
//                        self.navigationController?.pushViewController(pushVC!, animated: true)
                            if let viewControllers = self.navigationController?.viewControllers {
                                if viewControllers.count > 3 {
                                    self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                                } else {
                                            // fail
                                }
                            }
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
}
