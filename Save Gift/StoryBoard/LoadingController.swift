//
//  LoadingController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/02.
//

import Foundation
import UIKit
import LocalAuthentication

class LoadingController : UIViewController {
    let LOG_TAG : String = "LoadingController"
    @IBOutlet weak var logo: UIImageView!
    
    let localUrl : String = "".getLocalURL()
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    let deviceModel = GetDeviceModel.deviceModelName()
    let helper : Helper = Helper()
    let authContext = LAContext()
    
    var pushToken : String = "test"
    
    enum BiometryType {
        case faceId
        case touchId
        case none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "barcodeLogo")
        
        //DB insert 하는 부분 구현
        print("device model : ", deviceModel)
        
        // 아이디저장
        UserDefaults.standard.set(deviceID, forKey: "device_id")
        
        requestNotificationPermission()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            
            let type = self.getBiometryType()
            print("type ", type)
            if type == .faceId || type == .touchId {
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "UnlockController")
                self.navigationController?.pushViewController(pushVC!, animated: true)
//                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
//                self.navigationController?.pushViewController(pushVC!, animated: true)
            }else {
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
                self.navigationController?.pushViewController(pushVC!, animated: true)
            }
        }
    }
    
    func getBiometryType() -> BiometryType {
        authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
            case .faceID:
                return .faceId
            case .touchID:
                return .touchId
            default:
                return .none
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func requestNotificationPermission(){
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
                if didAllow {
                    print("Push: 권한 허용")
                } else {
                    print("Push: 권한 거부")
                }
            })
        }
    
    func exitApp() -> Void{
        exit(0)
    }
}
