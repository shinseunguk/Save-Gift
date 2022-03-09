//
//  GiftRank.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 랭킹보깈

import Foundation
import UIKit

class GiftFriendController : UIViewController{
    
    var arr1 : [String] = ["samdori96@nate.com","samdori92@nate.com","samdori96@nate.com","samdori92@nate.com"]
    var arr2 = ["samdori96@nate.com","samdori92@nate.com","samdori96@nate.com","samdori92@nate.com","samdori96@nate.com"]
    let localUrl : String = "".getLocalURL();
    var user_id : String?
    
    //기기 세로길이
    let screenHeight = UIScreen.main.bounds.size.height
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var uiView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftFriendController")
        
//        친구를 추가해 기프티콘을 선물, 공유 해보세요
        
        print("screenHeight : ", screenHeight)
        
        
        topTableView.delegate = self
        topTableView.delegate = self
        topTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        topTableView.isScrollEnabled = false


        bottomTableView.delegate = self
        bottomTableView.delegate = self
        bottomTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        bottomTableView.isScrollEnabled = false
        
//        if arr1.count == 0 {
//            topLabel.removeFromSuperview()
//            topTableView.removeFromSuperview()
//
//            bottomLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
//        }
//
//        if arr2.count == 0 {
//            bottomLabel.removeFromSuperview()
//            bottomTableView.removeFromSuperview()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        view.frame.size.height = 3000
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requestPost(requestUrl: "/getFriend")
    }
    
    func requestPost(requestUrl : String!) -> Void{
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

                    print("회원가입 응답 처리 로직 responseString", responseString)
                    print("응답 처리 로직 data", data! as Any)
                    print("응답 처리 로직 response", response! as Any)
                    // 응답 처리 로직
                    
                    if(responseString != ""){
                        DispatchQueue.main.async{
                            //view 추가
                            
                        }
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if tableView == self.topTableView {
            cell.textLabel?.text="\(indexPath.row)"
            cell.textLabel?.text = arr1[indexPath.row]
        }

        if tableView == self.bottomTableView {
            cell.textLabel?.text="\(indexPath.row)"
            cell.textLabel?.text = arr2[indexPath.row]
        }
        
//        topTableView.frame.size.height = 300
//        bottomTableView.frame.size.height = 100
        
        print("CGFloat(self.arr1.count * 50) ", CGFloat(self.arr1.count * 50))
//        topTableView.frame.size.height = self.topTableView.contentSize.height
//        bottomTableView.frame.size.height = self.bottomTableView.contentSize.height
        
//        bottomLabel.topAnchor.constraint(equalTo: topTableView.topAnchor, constant: self.topTableView.contentSize.height + 30).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: topTableView.topAnchor, constant: CGFloat(self.arr1.count * 50) + 30).isActive = true
        
        bottomTableView.frame.size.height = CGFloat(self.arr2.count * 50)
//        bottomTableView.contentSize.height = 300
        
//        uiView.frame.size.height = 300
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    //cell 여백 삭제
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    //cell 여백 삭제
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }

}
