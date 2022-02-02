//
//  LoadingController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/02.
//

import Foundation
import UIKit

class LoadingController : UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    let deviceModel = GetDeviceModel.deviceModelName()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "barcodeLogo")
        
        //DB insert 하는 부분 구현
        print("device model : ", deviceModel)
        
        // 아이디저장
        UserDefaults.standard.set(deviceModel, forKey: "device_id")
        
        requestNotificationPermission()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
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
}
