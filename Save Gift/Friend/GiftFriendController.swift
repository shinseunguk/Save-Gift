//
//  GiftRank.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  친구

import Foundation
import UIKit


class GiftFriendController : UIViewController{
    let LOG_TAG : String = "GiftFriend2Controller"
    let helper : Helper = Helper();
    let localUrl : String = "".getLocalURL();
    var user_id : String?
    
    var uiViewHeightConstraint : NSLayoutConstraint?
    var topTableViewHeightConstraint : NSLayoutConstraint?
    var bottomTableViewHeightConstraint : NSLayoutConstraint?
    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    let dismissBtn = UIButton()
    let topLabel = UILabel()
    let topTableView = UITableView()
    let bottomLabel = UILabel()
    let bottomTableView = UITableView()
    
    var arr1 : [String] = ["요청된 친구가 없습니다."]
    var arr2 : [String] = ["친구를 추가해 기프티콘을 선물, 공유 해보세요."]
    var status : [String] = []
//    var arr1 : [String] = ["aa@naver.com", "bb@naver.com", "cc@naver.com"] // TEST
//    var arr2 : [String] = ["krdut1@gmail.com"] // TEST
//    var status : [String] = ["W", "P", "W"] // TEST
    
    var getFriend : String?
    
    var dic : [String : Any] = [:];
    var dic2 : [String : Any] = [:];

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GiftFriend2Controller \(#function)")
        
        dismissBtnSetup()
        dismissBtnHidden() // X Btn 숨기기
        
        topLabelSetUp() // [친구 요청]
        topTableViewSetUp() // 친구요청 테이블뷰
        bottomLabelSetUp() // [친구]
        bottomTableViewSetUp() // 친구 테이블뷰
        uiViewSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool){
        print(#function)
        if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
            requestGetRequestFriend(requestUrl: "/getRequestFriend") // 친구 대기
        }
    }
    
    func dismissBtnSetup(){
        dismissBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissBtn.contentVerticalAlignment = .fill
        dismissBtn.contentHorizontalAlignment = .fill
        dismissBtn.tintColor = .systemBlue
//        dismissBtn.backgroundColor = .black
        dismissBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        self.scrollView.addSubview(dismissBtn)
        
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        dismissBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        dismissBtn.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 10).isActive = true
        dismissBtn.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 20).isActive = true
    }
    
    func dismissBtnHidden(){
        dismissBtn.isHidden = true
    }
    
    func topLabelSetUp(){
//        topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
        topLabel.textAlignment = .center
        topLabel.text = "[친구 요청]"
        topLabel.textColor = .systemGray2
//        topLabel.backgroundColor = .systemIndigo
        self.scrollView.addSubview(topLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topLabel.topAnchor.constraint(equalTo: dismissBtn.bottomAnchor, constant: 10).isActive = true
        topLabel.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 20).isActive = true
    }
    
    func topTableViewSetUp(){
        topTableView.isScrollEnabled = false
        
//        topTableView.backgroundColor = .systemIndigo
        topTableView.dataSource = self
        topTableView.delegate = self
        self.scrollView.addSubview(topTableView)
        topTableView.register(UINib(nibName: "GetFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "GetFriendTableViewCell")

//        topTableView.backgroundColor = .black
        topTableView.translatesAutoresizingMaskIntoConstraints = false
        topTableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10).isActive = true
        topTableView.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 10).isActive = true
        topTableView.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -10).isActive = true
//        topTableView.heightAnchor.constraint(equalToConstant: CGFloat(arr1.count * 50)).isActive = true
        topTableViewHeightConstraint = topTableView.heightAnchor.constraint(equalToConstant: CGFloat(arr1.count * 50))
        topTableViewHeightConstraint?.isActive = true
    }
    
    func bottomLabelSetUp(){
        bottomLabel.textAlignment = .center
        bottomLabel.text = "[친구]"
        bottomLabel.textColor = .systemGray2
        self.scrollView.addSubview(bottomLabel)
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bottomLabel.topAnchor.constraint(equalTo: topTableView.bottomAnchor, constant: 30).isActive = true
        bottomLabel.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 20).isActive = true
    }
    
    func bottomTableViewSetUp(){
        bottomTableView.isScrollEnabled = false
        
//        bottomTableView.backgroundColor = .systemIndigo
        bottomTableView.dataSource = self
        bottomTableView.delegate = self
        self.scrollView.addSubview(bottomTableView)
        bottomTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        bottomTableView.translatesAutoresizingMaskIntoConstraints = false
        bottomTableView.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 10).isActive = true
        bottomTableView.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 10).isActive = true
        bottomTableView.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -10).isActive = true
//        bottomTableView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 0).isActive = true
        bottomTableViewHeightConstraint = bottomTableView.heightAnchor.constraint(equalToConstant: CGFloat(arr2.count * 50))
        bottomTableViewHeightConstraint?.isActive = true
    }
    
    func uiViewSetUp(){
//        uiView.backgroundColor = .systemGreen
        let totalHeight = CGFloat((arr1.count * 50 + arr2.count * 50) + 140)
        
        print("totalHeight -----> ", totalHeight)
        uiView.translatesAutoresizingMaskIntoConstraints = false
//        uiView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        uiViewHeightConstraint = uiView.heightAnchor.constraint(equalToConstant: totalHeight)
        uiViewHeightConstraint?.isActive = true
    }
    
    
    @objc func dismissAction(){
        print("dismissAction")
        
        // constraint change
        self.uiViewHeightConstraint?.constant = 800
        self.topTableViewHeightConstraint?.constant = 300
//        self.view.layoutIfNeeded()
    }
    
    func normalAlert(title : String, message : String, email : String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if message == "친구가 수락 대기중입니다. 친구요청을 취소 하시겠습니까?" {
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel) { action in
                print("아니오")
            })
            alert.addAction(UIAlertAction(title: "요청취소", style: .default) { action in
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
        alert.addAction(UIAlertAction(title: "거절", style: .cancel) { action in
            print("거절")
            self.reAlert(email: email)
            //DB delete
        })
        alert.addAction(UIAlertAction(title: "수락", style: .destructive) { action in
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
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
            print("아니오")
            //DB delete
        })
        alert.addAction(UIAlertAction(title: "거절", style: .default) { action in
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
            alert.addAction(UIAlertAction(title: "선물하기(기프티콘)", style: .default) { action in
                print("선물하기")
            })
            alert.addAction(UIAlertAction(title: "친구삭제", style: .destructive) { action in
                print("친구삭제")
                self.requestDeleteFriend(requestUrl: "/delete/friend", friend: message!)
            })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
                print("취소")
            })
            
        self.present(alert, animated: true, completion: nil)
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
                        print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
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
                        
                        self.topTableView.reloadData()
                        
                        self.topTableViewHeightConstraint?.constant = CGFloat(self.arr1.count * 50)
                        self.uiViewHeightConstraint?.constant = CGFloat((self.arr1.count * 50 + self.arr2.count * 50) + 140)
                        
                        self.requestGetFriend(requestUrl: "/getFriend")
                     
//                        self.topTableViewSetUp()
//                        self.topTableHeight()
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
                        print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
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
                        
                        self.bottomTableView.reloadData()
                        
                        self.bottomTableViewHeightConstraint?.constant = CGFloat(self.arr2.count * 50)
                        self.uiViewHeightConstraint?.constant = CGFloat((self.arr1.count * 50 + self.arr2.count * 50) + 140)
                        
//                        self.bottomTableViewSetup()
//                        self.bottomTableHeight()
                    }
                }
                // POST 전송
                task.resume()
    }
    
    func requestDeleteFriend(requestUrl : String!, friend : String) -> Void{
            let param = ["user_id" : UserDefaults.standard.string(forKey: "ID")!, "friend" : friend] as [String : Any] // JSON 객체로 전송할 딕셔너리
    
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
                        
                        print("reponseString.. => ", responseString)
    
                            DispatchQueue.main.async{
                                //view 추가
                                if responseString == "1" {
                                    //friend
                                    
                                    if let Index = self.arr2.firstIndex(of: friend) {
                                        print("\(#line)",Index)  //
                                        self.arr2.remove(at: Index);
                                    }
                                    print("/deleteFriend arr1 after ------> ",self.arr2)
                                    
                                    //arr1.count != 0 -> == 0
                                    
                                    print("self.arr2.count ", self.arr2.count)
                                    if self.arr2.count == 0 {
                                        self.arr2.append("친구를 추가해 기프티콘을 선물, 공유 해보세요.")
                                    }
                                    
                                    self.normalAlert(title: "알림", message: "친구 삭제완료", email: nil)
                                    
                                    self.bottomTableView.reloadData()
                                    
                                    self.bottomTableViewHeightConstraint?.constant = CGFloat(self.arr2.count * 50)
                                    self.uiViewHeightConstraint?.constant = CGFloat((self.arr1.count * 50 + self.arr2.count * 50) + 140)

                                }else if responseString == "0" {// 실패시
//                                    print("/requestAddFriend ", responseString!)
                                    
                                    if let Index = self.arr2.firstIndex(of: friend) {
                                        print("\(#line) ",Index)  //
                                        self.arr2.remove(at: Index);
                                    }
                                    print("/deleteFriend arr1 after ------> ",self.arr2)
                                    
                                    //arr1.count != 0 -> == 0
                                    
                                    print("self.arr2.count ", self.arr2.count)
                                    if self.arr2.count == 0 {
                                        self.arr2.append("친구를 추가해 기프티콘을 선물, 공유 해보세요.")
                                    }
                                    
//                                    self.normalAlert(title: "알림", message: "친구 삭제완료", email: nil)
//                                    self.bottomTableView.reloadData()
//
//                                    self.bottomTableViewHeightConstraint?.constant = CGFloat(self.arr2.count * 50)
//                                    self.uiViewHeightConstraint?.constant = CGFloat((self.arr1.count * 50 + self.arr2.count * 50) + 140)
                                    
                                    
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
                            print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
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
                                    
                                    self.requestGetRequestFriend(requestUrl: "/getRequestFriend") // 친구 대기
                                    //self.topTableView.reloadData()
                                    //self.bottomTableView.reloadData()
                                    
                                }else if responseString == "0" {
                                    print("/requestAddFriend ", responseString!)
                                    self.requestGetRequestFriend(requestUrl: "/getRequestFriend") // 친구 대기
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()
                                    
                                }
                                
                            }
                        }
                    }
                    task.resume()
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
                            print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
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
                                    
                                    self.requestGetRequestFriend(requestUrl: "/getRequestFriend") // 친구 대기
                                    
//                                    self.topTableView.reloadData()
//                                    self.bottomTableView.reloadData()

                                }else if responseString == "0" {
                                    print("/requestAddFriend ", responseString!)
                                    self.requestGetRequestFriend(requestUrl: "/getRequestFriend") // 친구 대기
//                                    self.topTableView.reloadData()
//                                    self.bottomTableView.reloadData()
                                    
                                }
                                
                            }
                        }
                    }
                    task.resume()
        }
    
}



extension GiftFriendController: UITableViewDelegate, UITableViewDataSource{
    func refreshTableView() {
        print("\(#line) => refreshTableView()")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topTableView {
//            print("arr1.count ", arr1.count)
            return arr1.count
        }
        if tableView == bottomTableView {
//            print("arr2.count ", arr2.count)
            return arr2.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topTableView {
            let customCell = self.topTableView.dequeueReusableCell(withIdentifier: "GetFriendTableViewCell", for: indexPath) as! GetFriendTableViewCell
//            print("arr1[indexPath.row] ", arr1[indexPath.row])
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
            
            //dev-dream-world.tistory.com/31 tableview
            cell.textLabel?.text = arr2[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        // P ->  거절 / 수락       W -> 친구가 수락 대기중
        if tableView == topTableView {
//            print("arr1[indexPath.row] ", arr1[indexPath.row])
//            print("status[indexPath.row] ", status[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
