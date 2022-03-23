//
//  GiftRank.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  친구

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

                    var responseData : String = responseString as! String
                    print("requestGetFriendTop responseString", responseString!)
                    print("응답 처리 로직 data", data! as Any)
                    print("응답 처리 로직 response", response! as Any)
                    // 응답 처리 로직
                    DispatchQueue.main.async{
                        if(responseString != ""){
                            //view 추가
                            //값이있을때 배열에 넣기
                            let result = responseData.split(separator: "#", maxSplits: 1)
                            print("result ", result)
                            print("result[0] ", result[0])
                            print("result[1] ", result[1])
                            
                            self.arr1 = result[0].components(separatedBy: "&")
                            self.status = result[1].components(separatedBy: "&")
                            
                            print("self.arr1 ----------> ", self.arr1)
                            print("self.status ----------> ", self.status)
                            
                        }
//                        else{
//                            print("responseString == arr1")
//                            if self.arr1.count == 0 {
//                                print("요청된 친구가 없습니다.")
//                                self.arr1.append("요청된 친구가 없습니다.")
//                                self.status.append("")
//                            }
//                        }
                        
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
                                
                            if self.arr2[0] == ""{
                                self.arr2.remove(at: 0)
                                self.arr2.append("친구를 추가해 기프티콘을 선물, 공유 해보세요.")
                            }
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
                } else {
                    customCell.emailLabel?.textColor = UIColor.black
                    customCell.selectionStyle = .default
                }
            
            customCell.emailLabel.text = arr1[indexPath.row]
            if status.count != 0 {
                if status[indexPath.row] == "W"{
                    customCell.statusLabel.textColor = UIColor.systemIndigo
                    customCell.statusLabel.text = "친구가 수락대기중"
                } else if status[indexPath.row] == "P"{
                    customCell.statusLabel.textColor = UIColor.systemRed
                    customCell.statusLabel.text = "거절 / 수락"
                }
            }
            
            print("arr1.count * 50 ", arr1.count * 50)
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
                } else{
                    cell.textLabel?.textColor = UIColor.black
                    cell.selectionStyle = .default
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
        
        
        //P ->  거절 / 수락       W -> 친구가 수락 대기중
        if tableView == topTableView {
            print("arr1[indexPath.row] ", arr1[indexPath.row])
            print("status[indexPath.row] ", status[indexPath.row])
            if arr1[indexPath.row] != "요청된 친구가 없습니다." {
                if status[indexPath.row] == "W" {
                    self.normalAlert(title: "알림", message:  "친구가 수락 대기중입니다. 친구요청을 취소 하시겠습니까?", email: arr1[indexPath.row])
                } else{
                    self.alert(email: arr1[indexPath.row])
                }
            }
        }
        if tableView == bottomTableView {
            if arr2[indexPath.row] != "친구를 추가해 기프티콘을 선물, 공유 해보세요."{
                self.normalActionSheet(title: "기프티콘 저장소", message: arr2[indexPath.row])
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
    
    func normalAlert(title : String, message : String, email : String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if message == "친구가 수락 대기중입니다. 친구요청을 취소 하시겠습니까?" {
            alert.addAction(UIAlertAction(title: "아니오", style: .destructive) { action in
                print("아니오")
            })
            alert.addAction(UIAlertAction(title: "예", style: .default) { action in
                print("요청취소")
                self.requestDeleteFriendWait(requestUrl: "/deleteFriendWait", friend: email!, index: "me")
            })
        }else {
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                print("확인")
            })
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alert(email : String){
        let alert = UIAlertController(title: "알림", message: "\(email)님이 친구를 요청했습니다. 수락 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "거절", style: .destructive) { action in
            print("거절")
            self.reAlert(email: email)
            //DB delete
        })
        alert.addAction(UIAlertAction(title: "수락", style: .default) { action in
            print("수락")
            self.requestAddFriend(requestUrl: "/addFriend", friend : email)
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
        alert.addAction(UIAlertAction(title: "아니오", style: .destructive) { action in
            print("아니오")
            //DB delete
        })
        alert.addAction(UIAlertAction(title: "예", style: .default) { action in
            print("예")
            self.requestDeleteFriendWait(requestUrl: "/deleteFriendWait", friend: email, index: nil)
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
    
    func normalActionSheet(title : String?, message : String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "선물하기(선물)", style: .default) { action in
                print("선물하기")
            })
            alert.addAction(UIAlertAction(title: "파티초대(공유)", style: .default) { action in
                print("파티초대")
            })
        alert.addAction(UIAlertAction(title: "친구삭제", style: .destructive) { action in
            print("친구삭제")
        })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
                print("취소")
            })
            
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestAddFriend(requestUrl : String!, friend : String) -> Void{
            let param = ["user_id" : UserDefaults.standard.string(forKey: "ID"), "friend" : friend] as [String : Any] // JSON 객체로 전송할 딕셔너리
    
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
    
                        print("/addFriend", responseString!)
                        print("응답 처리 로직 data", data! as Any)
                        print("응답 처리 로직 response", response! as Any)
                        // 응답 처리 로직
    
    
                        if(responseString != ""){
                            DispatchQueue.main.async{
                                //view 추가
                                if responseString == "1" {
                                    print("/requestAddFriend ", responseString!)
                                    //friend
                                    //arr1 배열에서 검색후 제거
                                    print("/addFriend arr1 before ------> ",self.arr1)
                                    if let Index = self.arr1.firstIndex(of: friend) {
                                        print(Index)  //
                                        self.arr1.remove(at: Index);
                                        self.status.remove(at: Index);
                                    }
                                    print("/addFriend arr1 after ------> ",self.arr1)
                                    //arr2 배열 마지막에 추가
                                    
                                    //arr1.count != 0 -> == 0
                                    if self.arr1.count == 0 {
                                        self.arr1.append("요청된 친구가 없습니다.")
                                    }
                                    
                                    //arr2.count == 0 -> != 0
                                    if self.arr2[0] == "친구를 추가해 기프티콘을 선물, 공유 해보세요." {
                                        self.arr2.remove(at: 0)
                                    }
                                    
                                        print("/addFriend arr2 before ------> ",self.arr2)
                                        self.arr2.append(friend)
                                        print("/addFriend arr2 after ------> ",self.arr2)
                                    
                                    self.normalAlert(title: "알림", message: "친구 추가가 완료 되었습니다.", email: nil)
                                    
                                    
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()

                                }else if responseString == "0" {
                                    print("/requestAddFriend ", responseString!)
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()
                                    
                                }
                                
                            }
                        }
                    }
                    task.resume()
        }
    
    func requestDeleteFriendWait(requestUrl : String!, friend : String, index : String?) -> Void{
        let param = ["user_id" : UserDefaults.standard.string(forKey: "ID"), "friend" : friend, "index" : index] as [String : Any] // JSON 객체로 전송할 딕셔너리
    
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
    
                        print("/deleteFriendWait", responseString!)
                        print("응답 처리 로직 data", data! as Any)
                        print("응답 처리 로직 response", response! as Any)
                        // 응답 처리 로직
    
    
                        if(responseString != ""){
                            DispatchQueue.main.async{
                                //view 추가
                                if responseString == "1" {
                                    print("/requestDeleteFriendWait ", responseString!)
                                    //friend
                                    //arr1 배열에서 검색후 제거
                                    print("/deleteFriendWait arr1 before ------> ",self.arr1)
                                    if let Index = self.arr1.firstIndex(of: friend) {
                                        print(Index)  //
                                        self.arr1.remove(at: Index);
                                        self.status.remove(at: Index);
                                    }
                                    print("/deleteFriendWait arr1 after ------> ",self.arr1)
                                    //arr2 배열 마지막에 추가
                                    
                                    //arr1.count != 0 -> == 0
                                    if self.arr1.count == 0 {
                                        self.arr1.append("요청된 친구가 없습니다.")
                                    }
                                    
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()

                                }else if responseString == "0" {
                                    print("/requestAddFriend ", responseString!)
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()
                                    
                                }
                                
                            }
                        }
                    }
                    task.resume()
        }

}
