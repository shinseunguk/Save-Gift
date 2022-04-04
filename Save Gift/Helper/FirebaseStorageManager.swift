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
    static func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        //파일명(변경필요함)
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                print("url ", url!)
            }
        }
    }
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
//    func downloadimage(imgview:UIImageView){
//        storage.reference(forURL: "gs://firstios-f6c7c.appspot.com/password").downloadURL { (url, error) in
//                           let data = NSData(contentsOf: url!)
//                           let image = UIImage(data: data! as Data)
//                            imgview.image = image
//            }
//    }
}
