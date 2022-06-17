//
//  UnlockController.swift
//  Save Gift
//
//  Created by mac on 2022/06/17.
//

import Foundation
import LocalAuthentication
import UIKit

class UnlockController : UIViewController {
    
    let authContext = LAContext()
    var nextButton = UIButton()
    
    enum BiometryType {
        case faceId
        case touchId
        case none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lockBtn()
        
        let type = self.getBiometryType()
        if type == .faceId {
            nextButton.setImage(UIImage(systemName: "faceid"), for: .normal)
        } else if type == .touchId {
            nextButton.setImage(UIImage(systemName: "touchid"), for: .normal)
        } else {
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
        
        auth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    func getBiometryType() -> BiometryType {
        switch authContext.biometryType {
            case .faceID:
                return .faceId
            case .touchID:
                return .touchId
            default:
                return .none
        }
        
    }
    
    func lockBtn() {
        self.view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.backgroundColor = UIColor.black
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.tintColor = UIColor.white
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 15
        
        //imageview image size
        nextButton.setPreferredSymbolConfiguration(.init(pointSize: 35, weight: .regular, scale: .default), forImageIn: .normal)
        
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        nextButton.addTarget(self, action: #selector(unlockAction), for: .touchUpInside)
    }
    
    @objc
    func unlockAction() {
        // 생체인식 이후 적용해야함(두줄)
        auth()
    }
    
    func auth() {
        
        var error: NSError?
        var description: String!
        
        var authCount : Int = 0
        authContext.localizedCancelTitle = "취소"
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "서비스를 이용하기 위해 인증 합니다.") { (success, error) in
            print("인증결과", success, error)
            //Face ID 시도 횟수가 초과됨 \n Face ID를 사용할 수 없습니다.
            //스마트폰 Face ID가 잠겨있습니다. 잠금해제 후 다시 시도 해주세요.
            //스마트폰에 Face ID가 등록되어 있지 않습니다. Face ID 등록 후 다시 시도해주시기 바랍니다.
            
            
            if success {
                DispatchQueue.main.async{
                    let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
                    self.navigationController?.pushViewController(pushVC!, animated: true)
                }
            }else {
                switch error! {
                // 시스템(운영체제)에 의해 인증 과정이 종료 LAError.systemCancel:
                case LAError.systemCancel:
                    self.notifyUser1(msg: "시스템에 의해 중단되었습니다.", err: error?.localizedDescription)
                // 사용자가 취소함 LAError.userCancel
                case LAError.userCancel:
                    self.notifyUser1(msg: "인증이 취소 되었습니다.", err: error?.localizedDescription)
                // 터치아이디 대신 암호 입력 버튼을 누른경우(터치아이디 1회 틀리면 암호 입력 버튼 나옴) LAError.userFallback
                case LAError.userFallback:
                    self.notifyUser1(msg: "터치 아이디 인증", err: "암호 입력을 선택했습니다.")
                default:
                    self.notifyUser1(msg: "인증 실패", err: error?.localizedDescription)
                }
            }
        }
        }else {
            // 터치 아이디 사용할 수 없음
            switch error! {
            // 터치 아이디로 등록한 지문이 없다.
            case LAError.biometryNotEnrolled:
                self.notifyUser1(msg: "등록된 TouchID 혹은 지문이 없습니다.", err: error?.localizedDescription)
            // 디바이스의 패스코드를 설정 하지 않았다.
            case LAError.passcodeNotSet:
                self.notifyUser1(msg: "설정된 패스코드가 없습니다.", err: error?.localizedDescription)
            default:
                self.notifyUser1(msg: "터치아이디를 사용할 수 없습니다.", err: error?.localizedDescription)
            }
        }
        
    }
    
    func notifyUser1(msg: String, err: String?) {
        DispatchQueue.main.async{
            let alert =  UIAlertController(title: msg, message: err, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func notifyUser2(msg: String, err: String?) {
        DispatchQueue.main.async{
            let alert =  UIAlertController(title: msg, message: err, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "설정", style: .default, handler: {_ in self.goSetting()})
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func goSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}
