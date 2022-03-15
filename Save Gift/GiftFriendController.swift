//
//  GiftRank.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 랭킹보깈

import Foundation
import UIKit

class GiftFriendController : UIViewController{
    
//    var arr1 : [String] = ["arr1","arr2","arr3","arr4","arr5","arr6","arr1","arr2","arr3","arr4","arr5","arr6"]
//    var arr2 : [String] = ["ARR1","ARR2","ARR3","ARR4","ARR5","ARR6","ARR7","ARR8","ARR9","ARR10","ARR11","ARR12"]
//    var arr1 : [String] = ["samdori96@nate.com"]
    var tempArray : [String] = []
    var arr1 : [String] = ["요청된 친구가 없습니다."]
    var arr2 : [String] = ["친구를 추가해 기프티콘을 선물, 공유 해보세요."]
    var status : [String] = []
//    var status : [String] = ["친구 요청중","친구 요청중","친구 요청중","친구 요청중","친구 요청중","친구 요청중","친구 요청중","친구 요청중","친구 요청중","친구 요청중","친구 요청중","친구 요청중"]
    let localUrl : String = "".getLocalURL();
    var user_id : String?
    
    //기기 세로길이
    let screenHeight = UIScreen.main.bounds.size.height
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var getFriend : String?
    
    let helper : Helper = Helper();
    var dic : [String : Any] = [:];
    var dic2 : [String : Any] = [:];
    var stringDic : [String : String] = [:];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftFriendController")
        
//        친구를 추가해 기프티콘을 선물, 공유 해보세요
        
        print("screenHeight : ", screenHeight)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("GiftFriendController viewWillAppear")
        
        if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
            self.requestGetRequestFriend(requestUrl: "/getRequestFriend")
            self.requestGetFriend(requestUrl: "/getFriend")
        }
    }
    
    func requestGetRequestFriend(requestUrl : String!) -> Void{
        user_id = UserDefaults.standard.string(forKey: "ID")!
        let param = ["user_id" : user_id] as [String : Any] // JSON 객체로 전송할 딕셔너리
        
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

                    print("requestGetFriendTop responseString", responseString!)
                    print("응답 처리 로직 data", data! as Any)
                    print("응답 처리 로직 response", response! as Any)
                    // 응답 처리 로직
                    DispatchQueue.main.async{
                        if(responseString != ""){
                            //view 추가
                            //값이있을때 배열에 넣기
                            self.tempArray = (responseString?.components(separatedBy: "}"))!
                            self.tempArray.remove(at: self.tempArray.count-1)
                            print("self.tempArray ", self.tempArray)
                            print("self.tempArray.count ", self.tempArray.count)
                            
                            for x in 0...self.tempArray.count-1 {
                                self.tempArray[x] = self.tempArray[x].replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "[", with: "")
                                print("self.tempArray[x] ",self.tempArray[x])
                                
                                if x != 0{
                                    let startIndex = self.tempArray[x].index(self.tempArray[x].startIndex, offsetBy: 1)
                                    let range = startIndex...
                                    print("str[range] ", self.tempArray[x][range])
                                } else {
//                                    stringDic = self.tempArray[x]
                                }
                                
                                
                            }
                            
                        }
                        
                        self.topTableView.register(UINib(nibName: "GetFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "GetFriendTableViewCell")
                        self.topTableView.dataSource = self
                        self.topTableView.delegate = self
                        self.topTableView.isScrollEnabled = false
                        
                        self.topTableView.reloadData()
                    }
                }
                // POST 전송
                task.resume()
    }
    
    func requestGetFriend(requestUrl : String!) -> Void{
        user_id = UserDefaults.standard.string(forKey: "ID")!
        let param = ["user_id" : user_id] as [String : Any] // JSON 객체로 전송할 딕셔너리
        
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

                    print("requestGetFriendBottom responseString", responseString!)
                    print("응답 처리 로직 data", data! as Any)
                    print("응답 처리 로직 response", response! as Any)
                    // 응답 처리 로직
                    
                    DispatchQueue.main.async{
                        if responseString != "" {
                            
                                self.dic2 = self.helper.jsonParserName(stringData: responseString as! String, data1: "friend");
                                self.getFriend = self.dic2["friend"] as! String
                            
                                self.arr2 = (self.getFriend?.components(separatedBy: "&"))!
                                
                                print("dic###1 ", self.dic2["friend"] as! String)
                                print("self.arr2 ", self.arr2[0])
                                print("arr2### ", self.arr2)
                        }
//                        else {
//                            if self.arr2.count == 0{
//                                self.arr2.append("친구를 추가해 기프티콘을 선물, 공유 해보세요.")
//                            }
//                        }
                    
                    self.bottomTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                    self.bottomTableView.dataSource = self
                    self.bottomTableView.delegate = self
                    self.bottomTableView.isScrollEnabled = false
                    
                    self.bottomTableView.reloadData()
                    }
                }
                // POST 전송
                task.resume()
    }
    
}



extension GiftFriendController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topTableView {
            print("arr1.count ", arr1.count)
            return arr1.count
        }
        if tableView == bottomTableView {
            print("arr2.count ", arr2.count)
            return arr2.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topTableView {
            let customCell = self.topTableView.dequeueReusableCell(withIdentifier: "GetFriendTableViewCell", for: indexPath) as! GetFriendTableViewCell
            print("arr1[indexPath.row] ", arr1[indexPath.row])
                if arr1[0] == "요청된 친구가 없습니다."{
                        print("status[0]")
                        customCell.emailLabel?.textColor = UIColor.systemBlue
                        customCell.statusLabel.text = ""
                        customCell.emailLabel.text = "요청된 친구가 없습니다."
                        customCell.selectionStyle = .none
                }
            
            customCell.emailLabel.text = arr1[indexPath.row]
            if status.count != 0 {
                customCell.statusLabel.text = status[indexPath.row]
            }
            
            
            self.topTableView.frame.size.height = CGFloat(arr1.count * 50)
            let totalHeight = CGFloat(arr1.count * 50) + CGFloat(arr2.count * 50) + 34
            print("totalHeight -----> ", totalHeight)
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: totalHeight + 95)
            
            return customCell
        } else if tableView == bottomTableView {
            print("arr2[indexPath.row] ", arr2[indexPath.row])
            let cell = self.bottomTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
                if arr2[0] == "친구를 추가해 기프티콘을 선물, 공유 해보세요."{
                    cell.textLabel?.textColor = UIColor.systemBlue
                    cell.selectionStyle = .none
                }
            
            cell.textLabel?.text = arr2[indexPath.row]
            
            self.bottomTableView.frame.size.height = CGFloat(arr2.count * 50)
            bottomLabel.topAnchor.constraint(equalTo: topTableView.topAnchor, constant: CGFloat(self.arr1.count * 50) + 30).isActive = true
            var totalHeight = CGFloat(arr1.count * 50) + CGFloat(arr2.count * 50) + 34
            print("totalHeight -----> ", totalHeight)
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: totalHeight + 95)
            
            return cell
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if tableView == topTableView {
            if arr1[indexPath.row] != "요청된 친구가 없습니다."{
                print("click.. ", arr1[indexPath.row])
                self.alert(email: arr1[indexPath.row])
            }
        }
        if tableView == bottomTableView {
            if arr2[indexPath.row] != "친구를 추가해 기프티콘을 선물, 공유 해보세요."{
                print("click.. ", arr2[indexPath.row])
            }
        }
    }

    //cell 여백 삭제
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    //cell 여백 삭제
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func alert(email : String){
        let alert = UIAlertController(title: "알림", message: "\(email)님이 친구를 요청했습니다. 수락하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "거절", style: .default) { action in
            print("거절")
            self.reAlert(email: email)
            //DB delete
        })
        alert.addAction(UIAlertAction(title: "수락", style: .default) { action in
            print("수락")
            //DB delete후
            //DB insert
        })
        // 기능추가 예정
//        alert.addAction(UIAlertAction(title: "이 사용자 차단", style: .default) { action in
//            print("이 사용자 차단")
//        })
        self.present(alert, animated: true, completion: nil)
//        actionButton.isHidden = false
        
    }
    
    func reAlert(email : String){
        let alert = UIAlertController(title: "알림", message: "정말로 \(email)님을 거절 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .default) { action in
            print("아니오")
            //DB delete
        })
        alert.addAction(UIAlertAction(title: "거절", style: .default) { action in
            print("거절")
            //DB delete후
            //DB insert
        })
        // 기능추가 예정
//        alert.addAction(UIAlertAction(title: "이 사용자 차단", style: .default) { action in
//            print("이 사용자 차단")
//        })
        self.present(alert, animated: true, completion: nil)
//        actionButton.isHidden = false
        
    }

}
