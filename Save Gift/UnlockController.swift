//
//  MainController.swift
//  Save Gift
//테스트
//  Created by ukBook on 2021/12/18.
//

import Foundation
import UIKit
import LocalAuthentication

class UnlockController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainContrller")
        
        auth()
    }
    
    @IBAction func unlockAction(_ sender: Any) {
        print("unlockAction")
        auth()
    }
    
//    개발시에만 주석 ㅌㅅㅌ
//    override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//
//            navigationController?.setNavigationBarHidden(true, animated: animated)
//        }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    func auth() {
        
        let authContext = LAContext()
        var error: NSError?
        var description: String!

//        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            print("authContext.biometryType ", authContext.biometryType)
            switch authContext.biometryType {
            case .faceID:
                description = "서비스를 이용하기 위해 인증 합니다."
                break
            case .touchID:
                description = "서비스를 이용하기 위해 인증 합니다."
                break
            case .none:
                description = "서비스를 이용하기 위해 인증 합니다."
                break
            default:
                print("default")
                break
            }
            
//            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { (success, error) in
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: description) { (success, error) in
                if success {
                    print("인증 성공")
                    DispatchQueue.main.async{
//                    let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "main2Push")
//                            self.navigationController?.pushViewController(pushVC!, animated: true)
                        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
                                self.navigationController?.pushViewController(pushVC!, animated: true)
                    }
                } else {
                    print("인증 실패")
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }

    }
}
}
