//
//  AppDelegate.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/04.
//
// FCM 등록방법 https://developer-fury.tistory.com/53
// 키보드 화면 가림 현상 간단하게 해결하기 https://velog.io/@kerri/iOS-Swift-키보드-화면-가림-현상-간단하게-해결하기

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Firebase
import AuthenticationServices // 생체 인식
import IQKeyboardManagerSwift // 키보드 화면 가림 현상

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let localUrl : String = "".getLocalURL()
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    let deviceModel = GetDeviceModel.deviceModelName()
    let helper : Helper = Helper()
    
    var dic : Dictionary<String, Any> = [:]


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //키보드 화면 가림 현상
        IQKeyboardManager.shared.enable = true
        
        //네트워크 상태 체크
        NetworkCheck.shared.startMonitoring()
        
        KakaoSDK.initSDK(appKey: "0defae802c94b16017d351a984be5ef3")
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
        
        // apple ID 어플과 연동 상태 확인
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "00000.abcabcabcabc.0000") { (credentialState, error) in
            switch credentialState {
            case .authorized:// 이미 증명이 된경우
                print("authorized")
            // The Apple ID credential is valid.
            case .revoked: // 증명을 취소 했을 때
                print("revoked")
            case .notFound:// 증명이 존재하지 않을경우
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                print("notFound")
                DispatchQueue.main.async {
                    // self.window?.rootViewController?.showLoginViewController()
                }
            default:
                break
            }
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("앱 종료")
        UserDefaults.standard.removeObject(forKey: "lock")
    }
    
    func requestPost(requestUrl : String!, dic : Dictionary<String, Any>) -> Void{
        print("AppDelegate Device Insert => \n", dic)
//        let param = ["device_model" : deviceModel, "device_id" : deviceID, "push_token" : pushToken, "push_yn" : 1 ,"push30" : 1, "push7" : 1 ,"push1" : 1] as [String : Any] // JSON 객체로 전송할 딕셔너리
//        let param = "user_Id=\(email)&name=\(name)"
        let paramData = try! JSONSerialization.data(withJSONObject: dic)
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
                        print("네트워크에 접속할 수 없습니다.")
                        return
                    }
                    
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("Device insert / update 응답 처리 로직 responseString", responseString!)
//                    print("응답 처리 로직 data", data as Any)
//                    print("응답 처리 로직 response", response as Any)
                    // 응답 처리 로직
                    if(responseString == "true"){
                        DispatchQueue.main.async{
                            print("Device insert / update SUCCESS")
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
 }


extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
      print("[Log] deviceToken :", deviceTokenString)
        
      Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        dic["device_model"] = deviceModel
        dic["device_id"] = deviceID
        dic["push_token"] = fcmToken!
        dic["push_yn"] = 1
        dic["push30"] = 1
        dic["push7"] = 1
        dic["push1"] = 1
        
        // user_device DB insert
        requestPost(requestUrl: "/device/insert", dic: dic)
        
        print("파이어베이스 토큰: \(fcmToken!)")
    }
}
