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
    var dic2 : [String: Any] = [:];
    var push_yn : Int?
    var sms_yn : Int?
    var email_yn : Int?
    
    var push30 : Int?
    var push7 : Int?
    var push1 : Int?
    
    let deviceID : String? = UserDefaults.standard.string(forKey: "device_id")
    
    
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
            requestStatus2(requestUrl: "/status2")
        }else{
            tableViewSecond.removeFromSuperview()
            requestStatus2(requestUrl: "/status2")
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
            
            dic = helper.jsonParser3(stringData: response, data1: "email_yn", data2: "sms_yn", data3: "push_yn");
            
            print("\(LOG_TAG) dic... ########## \n",dic);
            

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
            
            self.tableViewSecond.dataSource = self
            self.tableViewSecond.delegate = self
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    
    }
    
    func requestStatus2(requestUrl : String!){
        do {
            // URL 설정 GET 방식으로 호출
            let url = URL(string: localUrl+requestUrl+"?device_id="+deviceID!)
            let response = try String(contentsOf: url!)
            
            dic2 = helper.jsonParser4(stringData: response, data1: "push_yn", data2: "push30", data3: "push7", data4: "push1");
            
            print("dic2 .. ", dic2)
            
            if self.dic2["push_yn"] as! Int == 1{
                self.arrayBoll1[0] = true
            }else {
                self.arrayBoll1[0] = false
            }
            
            if self.dic2["push30"] as! Int == 1{
                self.arrayBoll1[1] = true
            }else {
                self.arrayBoll1[1] = false
            }
            
            if self.dic2["push7"] as! Int == 1{
                self.arrayBoll1[2] = true
            }else {
                self.arrayBoll1[2] = false
            }
            
            if self.dic2["push1"] as! Int == 1{
                self.arrayBoll1[3] = true
            }else {
                self.arrayBoll1[3] = false
            }
            
            self.tableViewFirst.dataSource = self
            self.tableViewFirst.delegate = self
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
           cell.uiSwitch.addTarget(self, action: #selector(changeSwitch1(_:)), for: UIControl.Event.valueChanged)
            return cell
        }else {
            cell.label.font = UIFont.boldSystemFont(ofSize: 17)
           cell.label.text = arr2[indexPath.row]
            
           cell.uiSwitch.tag = indexPath.row
            cell.uiSwitch.isOn = arrayBoll2[indexPath.row]
           cell.uiSwitch.addTarget(self, action: #selector(changeSwitch2(_:)), for: UIControl.Event.valueChanged)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
    
    @objc func changeSwitch1(_ sender: UISwitch) {
        print(arr1[sender.tag] + "But \(sender.isOn) Became")
        switch arr1[sender.tag] {
        case "알림설정":
            if(sender.isOn){
                print("알림설정 ON")
                arrayBoll1[0] = true
            }else {
                arrayBoll1[0] = false
                print("알림설정 OFF")
            }
            break
        case "30일 전부터 알림":
            if(sender.isOn){
                print("30일 전부터 알림 ON")
                arrayBoll1[1] = true
            }else {
                print("30일 전부터 알림 OFF")
                arrayBoll1[1] = false
            }
            break
        case "7일 전부터 알림":
            if(sender.isOn){
                print("7일 전부터 알림 ON")
                arrayBoll1[2] = true
            }else {
                print("7일 전부터 알림 OFF")
                arrayBoll1[2] = false
            }
            break
        case "1일 전부터 알림":
            if(sender.isOn){
                print("1일 전부터 알림 ON")
                arrayBoll1[3] = true
            }else {
                print("1일 전부터 알림 OFF")
                arrayBoll1[3] = false
            }
            break
        default:
            print("default")
        }
        
        requestPost(requestUrl: "/notisetting", index: 0)
    }
    
    @objc func changeSwitch2(_ sender: UISwitch) {
        print(arr2[sender.tag] + "But \(sender.isOn) Became")
        
        switch arr2[sender.tag] {
        case "이메일":
            if(sender.isOn){
                print("이메일 ON")
                arrayBoll2[0] = true
            }else {
                arrayBoll2[0] = false
                print("이메일 OFF")
            }
            break
        case "SMS(문자)":
            if(sender.isOn){
                print("SMS(문자) ON")
                arrayBoll2[1] = true
            }else {
                print("SMS(문자) OFF")
                arrayBoll2[1] = false
            }
            break
        default:
            print("default")
        }
        
        requestPost(requestUrl: "/notisetting", index: 1)
    }
    
    func requestPost(requestUrl : String!, index : Int) -> Void{
        
//        "push_yn": 0 "push30": 0, "push7": 1, "push1": 1,
        if index == 0 {
            if(arrayBoll1[0]){
                push_yn = 1
            } else{
                push_yn = 0
            }

            if(arrayBoll1[1]){
                push30 = 1
            } else{
                push30 = 0
            }

            if(arrayBoll1[2]){
                push7 = 1
            } else{
                push7 = 0
            }
            
            if(arrayBoll1[3]){
                push1 = 1
            } else{
                push1 = 0
            }
            
            let param = ["index" : 0, "device_id" : deviceID! ,"push_yn" : push_yn, "push30" : push30, "push7" : push7, "push1" : push1] as [String : Any]
            
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
        }else{
            if(arrayBoll2[0]){
                email_yn = 1
            } else{
                email_yn = 0
            }

            if(arrayBoll2[1]){
                sms_yn = 1
            } else{
                sms_yn = 0
            }
            let param = ["index" : 1, "user_id" : UserDefaults.standard.string(forKey: "ID")! ,"email_yn" : email_yn, "sms_yn" : sms_yn] as [String : Any]
            
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
    
    
}
