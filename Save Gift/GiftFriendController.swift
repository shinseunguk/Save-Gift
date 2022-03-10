//
//  GiftRank.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 랭킹보깈

import Foundation
import UIKit

class GiftFriendController : UIViewController{
    
//    var arr1 : [String] = ["arr1","arr2","arr3","arr4","arr5","arr6","arr7","arr8","arr9"]
    var arr2 : [String] = ["ARR1","ARR2","ARR3","ARR4","ARR5","ARR6"]
//    var arr1 : [String] = ["samdori96@nate.com"]
    var arr1 : [String] = []
//    var arr2 : [String] = []
    var status : [String] = ["친구 요청중"]
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if arr1.count == 0{
            arr1.append("요청된 친구가 없습니다.")
        }
        
        if arr2.count == 0{
            arr2.append("친구를 추가해 기프티콘을 선물, 공유 해보세요.")
        }
        
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
            if arr1[0] == "요청된 친구가 없습니다."{
                cell.textLabel?.textColor = UIColor.systemBlue
                cell.selectionStyle = .none
            }
            cell.textLabel?.text="\(indexPath.row)"
            cell.textLabel?.text = arr1[indexPath.row]
        }

        if tableView == self.bottomTableView {
            if arr2[0] == "친구를 추가해 기프티콘을 선물, 공유 해보세요."{
                cell.textLabel?.textColor = UIColor.systemBlue
                cell.selectionStyle = .none
            }
            print("arr2[indexPath.row] ", arr2[indexPath.row])
            cell.textLabel?.text="\(indexPath.row)"
            cell.textLabel?.text = arr2[indexPath.row]
        }
        
//        topTableView.frame.size.height = CGFloat(self.arr1.count * 50)
        bottomTableView.frame.size.height = CGFloat(self.arr2.count * 50)
        bottomLabel.topAnchor.constraint(equalTo: topTableView.topAnchor, constant: CGFloat(self.arr1.count * 50) + 30).isActive = true
//        bottomTableView.topAnchor.constraint(equalTo: topTableView.topAnchor, constant: CGFloat(self.arr1.count * 50) + 60).isActive = true
        
        
        var totalHeight : Double = topTableView.frame.height + bottomTableView.frame.height + topLabel.frame.height + bottomLabel.frame.height
        print("totalHeight -----> ", totalHeight)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: totalHeight + 95.0)
        
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
