//
//  FirebaseStorageManager.swift
//  Save Gift
//
//  Created by mac on 2022/04/04.
//

import UIKit
import FirebaseStorage
import Firebase

class FirebaseStorageManager {
    static func uploadImage(image: UIImage) -> Bool {
        
        let deviceID : String? = UserDefaults.standard.string(forKey: "device_id")
        let helper : Helper = Helper()
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {return false}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        //파일명(변경필요함)
        let imageName = deviceID! + "_" + helper.formatDateTime()
        print("imageName ", imageName)
        
        let firebaseReference = Storage.storage().reference().child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                print("url ", url!)
                UserDefaults.standard.set(url!.absoluteString, forKey: "FirebaseURL")
            }
        }
        return true
    }
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))// UIImage to String 변환후 DBinsert
        }
    }
    
//    func downloadimage(imgview:UIImageView){
//        storage.reference(forURL: "gs://save-gift.appspot.com/DD15A014-F02C-4F28-BD0F-249B307BFA7A_202204042255").downloadURL { (url, error) in
//                           let data = NSData(contentsOf: url!)
//                           let image = UIImage(data: data! as Data)
//                            imgview.image = image
//            }
//    }
}
