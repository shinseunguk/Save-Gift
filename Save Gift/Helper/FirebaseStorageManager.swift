//
//  FirebaseStorageManager.swift
//  Save Gift
//
//  Created by mac on 2022/04/04.
//
// https://www.sentinelstand.com/article/guide-to-firebase-storage-download-urls-tokens

import UIKit
import FirebaseStorage
import Firebase

class FirebaseStorageManager {
    
    static let localUrl : String = "".getLocalURL()
    static let deviceID : String? = UserDefaults.standard.string(forKey: "device_id")
    static let helper : Helper = Helper()
    
    static func uploadImage(image: UIImage, param : inout Dictionary<String, Any>) -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {return false}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        //파일명(변경필요함)
        let imageName = deviceID! + "_" + helper.formatDateTime()
        print("imageName ", imageName)
        param["img_url"] = "gs://save-gift-e3710.appspot.com/"+imageName
        print("param .....1 ",param)
        
        let firebaseReference = Storage.storage().reference().child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                print("url ", url!)
                print("imageName ", imageName)
            }
        }
        requestPost(requestUrl: "/register/gift", param: param)
        return true
    }
    
//    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
//        let storageReference = Storage.storage().reference(forURL: urlString)
//        let megaByte = Int64(1 * 1024 * 1024)
//
//        storageReference.getData(maxSize: megaByte) { data, error in
//            guard let imageData = data else {
//                completion(nil)
//                return
//            }
//            completion(UIImage(data: imageData))// UIImage to String 변환후 DBinsert
//        }
//    }
    
    func downloadimage(imgview:UIImageView, urlString: String){
        //"gs://save-gift-e3710.appspot.com/DD15A014-F02C-4F28-BD0F-249B307BFA7A_202204042255"
        Storage.storage().reference(forURL: "gs://save-gift-e3710.appspot.com/" + urlString).downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            imgview.image = image
        }
    }
    
    static func requestPost(requestUrl : String!, param : Dictionary<String, Any>) -> Void{

//        registerDic[0] -> 교환처
//        registerDic[1] -> 상품명
//        registerDic[2] -> 바코드 번호
//        registerDic[3] -> 유효기간
//        registerDic[4] -> 쿠폰 상태
//        registerDic[5] -> 등록일
//        registerDic[6] -> 등록자

        
        print("param .....2 ", param)
        let paramData = try! JSONSerialization.data(withJSONObject: param)
        // URL 객체 정의r
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

//                    if(responseString == "true"){
//                        DispatchQueue.main.async{
//                            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "tabbarVC") as? CustomTabBarController else{
//                                return
//                            }
//
//                            pushVC.VC = self.VC
//
//                            self.navigationController?.pushViewController(pushVC, animated: true)
//
//
//
//                        // 아이디저장
//                        UserDefaults.standard.set(email, forKey: "ID")
//
//                            self.requestGet(user_id : UserDefaults.standard.string(forKey: "ID")! , requestUrl : "/status")
//                        }
//                    } else if(responseString == "false"){
//                        DispatchQueue.main.async{
//                        self.normalAlert(titles: "로그인 실패", messages: "아이디와 비밀번호를 확인해주세요.")
//                        }
//                    }
                }
                // POST 전송
                task.resume()
    }
//    allow read, write
    
}
