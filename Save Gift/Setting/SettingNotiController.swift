//
//  SettingNotiController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/13.
//

import Foundation
import UIKit

class SettingNotiController : UIViewController {
    let LOG_TAG : String = "SettingNotiController";
    
    @IBOutlet weak var tableViewFirst: UITableView!
    @IBOutlet weak var tableViewSecond: UITableView!
    
    var arr1 = ["알림설정","30일 전부터 알림", "7일 전부터 알림", "1일 전부터 알림"]
    var arr2 = ["이메일","SMS(문자)"];
    var arrayBoll1 = [true, true, true, true];
    var arrayBoll2 = [true, true];
    let localUrl = "".getLocalURL();
    
    let helper : Helper = Helper();
    var dic : [String: Any] = [:];
    var push_yn : Int?
    var sms_yn : Int?
    var email_yn : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "알림설정"
        
        //셀 테두리지우기
        tableViewFirst.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableViewSecond.separatorStyle = UITableViewCell.SeparatorStyle.none
        //스크롤 enable
        tableViewFirst.isScrollEnabled = false
        tableViewSecond.isScrollEnabled = false
        //테이블뷰 선택 enable
        tableViewFirst.allowsSelection = false
        tableViewSecond.allowsSelection = false
        
        if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
            requestGet(user_id : UserDefaults.standard.string(forKey: "ID")! , requestUrl : "/status")
        }else{
            tableViewSecond.removeFromSuperview()
        }
        
        //Specify the xib file to use
        tableViewFirst.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableViewSecond.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    func requestGet(user_id : String!, requestUrl : String!){
        do {
            // URL 설정 GET 방식으로 호출
            let url = URL(string: localUrl+requestUrl+"?user_id="+user_id!)
            let response = try String(contentsOf: url!)
            
//            print("success")
//            print("#########response", response)
            dic = helper.jsonParser3(stringData: response, data1: "email_yn", data2: "sms_yn", data3: "push_yn");
            
            print("\(LOG_TAG) dic... ########## \n",dic);
            
            //추가
            if(dic["push_yn"] as! Int == 1){
                arrayBoll1[0] = true;
            } else{
                arrayBoll1[0] = false;
            }

            if(dic["email_yn"] as! Int == 1){
                arrayBoll2[0] = true;
            } else{
                arrayBoll2[0] = false;
            }

            if(dic["sms_yn"] as! Int == 1){
                arrayBoll2[1] = true;
            } else{
                arrayBoll2[1] = false;
            }
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    
    }
}

extension SettingNotiController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewFirst{
            return arr1.count
        }else if tableView == tableViewSecond{
            return arr2.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = arr[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        if tableView == tableViewFirst{
            
            if indexPath.row == 0 {
                cell.label.font = UIFont.boldSystemFont(ofSize: 17)
            }
            
            cell.label.text = arr1[indexPath.row]
           cell.uiSwitch.tag = indexPath.row
            cell.uiSwitch.isOn = arrayBoll1[indexPath.row]
           cell.uiSwitch.addTarget(self, action: #selector(changeSwitch(_:)), for: UIControl.Event.valueChanged)
            return cell
        }else {
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
           cell.label.text = arr2[indexPath.row]
            
           cell.uiSwitch.tag = indexPath.row
            cell.uiSwitch.isOn = arrayBoll2[indexPath.row]
           cell.uiSwitch.addTarget(self, action: #selector(changeSwitch(_:)), for: UIControl.Event.valueChanged)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
    
    @objc func changeSwitch(_ sender: UISwitch) {
            print(arr1[sender.tag] + "But\(sender.isOn)Became")
        
//        switch arr2[sender.tag] {
//        case "알림설정":
//            if(sender.isOn){
//                print("알림설정 ON")
//                arrayBoll[0] = true
//            }else {
//                arrayBoll[0] = false
//                print("알림설정 OFF")
//            }
//            break
//        case "이메일":
//            if(sender.isOn){
//                print("이메일 ON")
//                arrayBoll[1] = true
//            }else {
//                print("이메일 OFF")
//                arrayBoll[1] = false
//            }
//            break
//        case "SMS(문자)":
//            if(sender.isOn){
//                print("SMS(문자) ON")
//                arrayBoll[2] = true
//            }else {
//                print("SMS(문자) OFF")
//                arrayBoll[2] = false
//            }
//            break
//        default:
//            print("default")
//        }
        requestPost(requestUrl: "/notisetting")
        }
    
    func requestPost(requestUrl : String!) -> Void{
//        let email = idTextField.text
//        let password = passwordTextField.text
//        if(arrayBoll[0]){
//            push_yn = 1
//        } else{
//            push_yn = 0
//        }
//
//        if(arrayBoll[1]){
//            email_yn = 1
//        } else{
//            email_yn = 0
//        }
//
//        if(arrayBoll[2]){
//            sms_yn = 1
//        } else{
//            sms_yn = 0
//        }
        
        let param = ["user_id" : UserDefaults.standard.string(forKey: "ID")! ,"push_yn" : push_yn, "email_yn" : email_yn, "sms_yn" : sms_yn] as [String : Any] // JSON 객체로 전송할 딕셔너리
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
                        print("성공")
                    } else if(responseString == "false"){
                        print("실패")
                    }
                }
                // POST 전송
                task.resume()
    }
    
    
}
