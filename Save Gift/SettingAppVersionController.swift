//
//  SettingAppVersion.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/13.
//

import Foundation
import UIKit

class SettingAppVersionController : UIViewController {
    @IBOutlet weak var recentVersion: UILabel!
    @IBOutlet weak var installedVersion: UILabel!
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String else {return nil}
        let versionAndBuild: String = "version: \(version), build: \(build)"
        return version
    }
    let localUrl : String = "".getLocalURL();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "앱버전"
        
        installedVersion.text = "현재 버전 : \(version!)"
        
        requestGet(requestUrl: "/version")
    }
    
    func requestGet(requestUrl : String!){
        do {
            // URL 설정 GET 방식으로 호출
            let url = URL(string: localUrl+requestUrl)
            let response = try String(contentsOf: url!)
            
//            print("success")
//            print("#########response", response)
//            print(type(of: response))
            
            recentVersion.text = "최신 버전 : \(response)"
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
}
