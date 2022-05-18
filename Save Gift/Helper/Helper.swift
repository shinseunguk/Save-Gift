//
//  Helper.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/23.
//

import Foundation
import UIKit

class Helper : UIViewController{
    
    let localUrl : String = "".getLocalURL()
    
    func jsonParser(stringData : String, data1 : String?, data2 : String?) -> Dictionary<String, Any>{
        let strJsonString = stringData
//        print(strJsonString)
        let oJsonDataT:Data? = strJsonString.data(using: .utf8)
        var oJsonDictionaryT:[String:Any]?
        
        if let oJsonData = oJsonDataT{
            
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT{
                if let strResultCode = oJsonDictionary[data1!],
                    let strDescription = oJsonDictionary[data2!]
                   {
                    print("data1 = \(strResultCode)")
                    print("data2 = \(strDescription)")
                }
            }
            return oJsonDictionaryT!;
        }
        return oJsonDictionaryT!;
    }//func
    
    func jsonParser3(stringData : String, data1 : String?, data2 : String?, data3 : String?) -> Dictionary<String, Any>{
        let strJsonString = stringData
//        print(strJsonString)
        let oJsonDataT:Data? = strJsonString.data(using: .utf8)
        var oJsonDictionaryT:[String:Any]?
        
        if let oJsonData = oJsonDataT{
            
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT{
                if let strResultCode = oJsonDictionary[data1!],
                    let strDescription = oJsonDictionary[data2!],
                    let strDescription2 = oJsonDictionary[data3!]
                   {
                    print("data1 = \(strResultCode)")
                    print("data2 = \(strDescription)")
                    print("data3 = \(strDescription2)")
                }
            }
            return oJsonDictionaryT!;
        }
        return oJsonDictionaryT!;
    }//func
    
    func jsonParser4(stringData : String, data1 : String?, data2 : String?, data3 : String?, data4 : String?) -> Dictionary<String, Any>{
        let strJsonString = stringData
//        print(strJsonString)
        let oJsonDataT:Data? = strJsonString.data(using: .utf8)
        var oJsonDictionaryT:[String:Any]?
        
        if let oJsonData = oJsonDataT{
            
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT{
                if let strResultCode = oJsonDictionary[data1!],
                    let strDescription = oJsonDictionary[data2!],
                    let strDescription2 = oJsonDictionary[data3!],
                    let strDescription3 = oJsonDictionary[data4!]
                   {
                    print("data1 = \(strResultCode)")
                    print("data2 = \(strDescription)")
                    print("data3 = \(strDescription2)")
                    print("data4 = \(strDescription3)")
                }
            }
            return oJsonDictionaryT!;
        }
        return oJsonDictionaryT!;
    }//func
    
    func jsonParser5(stringData : String, data1 : String?, data2 : String?, data3 : String?, data4 : String?, data5 : String?) -> Dictionary<String, Any>{
        let strJsonString = stringData
//        print(strJsonString)
        let oJsonDataT:Data? = strJsonString.data(using: .utf8)
        var oJsonDictionaryT:[String:Any]?
        
        if let oJsonData = oJsonDataT{
            
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT{
                if let strResultCode = oJsonDictionary[data1!],
                    let strDescription = oJsonDictionary[data2!],
                    let strDescription2 = oJsonDictionary[data3!],
                    let strDescription3 = oJsonDictionary[data4!],
                    let strDescription4 = oJsonDictionary[data5!]
                   {
                    print("data1 = \(strResultCode)")
                    print("data2 = \(strDescription)")
                    print("data3 = \(strDescription2)")
                    print("data4 = \(strDescription3)")
                    print("data5 = \(strDescription4)")
                }
            }
            return oJsonDictionaryT!;
        }
        return oJsonDictionaryT!;
    }//func
    
    func jsonParser6(stringData : String, data1 : String?, data2 : String?, data3 : String?, data4 : String?, data5 : String?, data6 : String?) -> Dictionary<String, Any>{
        let strJsonString = stringData
//        print(strJsonString)
        let oJsonDataT:Data? = strJsonString.data(using: .utf8)
        var oJsonDictionaryT:[String:Any]?
        
        if let oJsonData = oJsonDataT{
            
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT{
                if let strResultCode = oJsonDictionary[data1!],
                    let strDescription = oJsonDictionary[data2!],
                    let strDescription2 = oJsonDictionary[data3!],
                    let strDescription3 = oJsonDictionary[data4!],
                    let strDescription4 = oJsonDictionary[data5!],
                   let strDescription5 = oJsonDictionary[data6!]
                   {
                    print("data1 = \(strResultCode)")
                    print("data2 = \(strDescription)")
                    print("data3 = \(strDescription2)")
                    print("data4 = \(strDescription3)")
                    print("data5 = \(strDescription4)")
                    print("data6 = \(strDescription5)")
                }
            }
            return oJsonDictionaryT!;
        }
        return oJsonDictionaryT!;
    }//func
    
    func jsonParser7(stringData : String, data1 : String?, data2 : String?, data3 : String?, data4 : String?, data5 : String?, data6 : String?, data7 : String?) -> Dictionary<String, Any>{
        let strJsonString = stringData
//        print(strJsonString)
        let oJsonDataT:Data? = strJsonString.data(using: .utf8)
        var oJsonDictionaryT:[String:Any]?
        
        if let oJsonData = oJsonDataT{
            
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT{
                if let strResultCode = oJsonDictionary[data1!],
                    let strDescription = oJsonDictionary[data2!],
                    let strDescription2 = oJsonDictionary[data3!],
                    let strDescription3 = oJsonDictionary[data4!],
                    let strDescription4 = oJsonDictionary[data5!],
                    let strDescription5 = oJsonDictionary[data6!],
                    let strDescription6 = oJsonDictionary[data7!]
                   {
                    print("data1 = \(strResultCode)")
                    print("data2 = \(strDescription)")
                    print("data3 = \(strDescription2)")
                    print("data4 = \(strDescription3)")
                    print("data5 = \(strDescription4)")
                    print("data6 = \(strDescription5)")
                    print("data7 = \(strDescription6)")
                }
            }
            return oJsonDictionaryT!;
        }
        return oJsonDictionaryT!;
    }//func
    
    func jsonParser9(stringData : String, data1 : String?, data2 : String?, data3 : String?, data4 : String?, data5 : String?, data6 : String?, data7 : String?, data8 : String?, data9 : String?) -> Dictionary<String, Any>{
        let strJsonString = stringData
//        print(strJsonString)
        let oJsonDataT:Data? = strJsonString.data(using: .utf8)
        var oJsonDictionaryT:[String:Any]?
        
        if let oJsonData = oJsonDataT{
            
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT{
                if let strResultCode = oJsonDictionary[data1!],
                    let strDescription = oJsonDictionary[data2!],
                    let strDescription2 = oJsonDictionary[data3!],
                    let strDescription3 = oJsonDictionary[data4!],
                    let strDescription4 = oJsonDictionary[data5!],
                    let strDescription5 = oJsonDictionary[data6!],
                    let strDescription6 = oJsonDictionary[data7!],
                   let strDescription7 = oJsonDictionary[data8!],
                   let strDescription8 = oJsonDictionary[data9!]
                   {
                    print("data1 = \(strResultCode)")
                    print("data2 = \(strDescription)")
                    print("data3 = \(strDescription2)")
                    print("data4 = \(strDescription3)")
                    print("data5 = \(strDescription4)")
                    print("data6 = \(strDescription5)")
                    print("data7 = \(strDescription6)")
                    print("data8 = \(strDescription7)")
                    print("data9 = \(strDescription8)")
                }
            }
            return oJsonDictionaryT!;
        }
        return oJsonDictionaryT!;
    }//func
    
    func jsonParserName(stringData : String, data1 : String?) -> Dictionary<String, Any>{
        let strJsonString = stringData
//        print(strJsonString)
        let oJsonDataT:Data? = strJsonString.data(using: .utf8)
        var oJsonDictionaryT:[String:Any]?
        
        if let oJsonData = oJsonDataT{
            
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT{
                if let strResultCode = oJsonDictionary[data1!]
                   {
                    print("data1 = \(strResultCode)")
                }
            }
            return oJsonDictionaryT!;
        }
        return oJsonDictionaryT!;
    }//func
    
    //오늘날짜 가져오기
    func formatDateToday() -> String{
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        
        return str
    }
    
    //오늘날짜 가져오기
    func formatDateTime() -> String{
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyyMMdd_HHmmss" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        
        return str
    }

    func getVersion(requestUrl : String!) -> String{
        do {
            // URL 설정 GET 방식으로 호출
            let url = URL(string: localUrl+requestUrl)
            let response = try String(contentsOf: url!)
            
//            print("success")
//            print("#########response", response)
//            print(type(of: response))
            
//            recentVersion.text = "최신 버전 : \(response)"
            
            return response
            
        } catch let e as NSError {
            print(e.localizedDescription)
            return e.localizedDescription
        }
    }
    
    func showLoading() {
            DispatchQueue.main.async {
                // 아래 윈도우는 최상단 윈도우
                guard let window = UIApplication.shared.windows.last else { return }

                let loadingIndicatorView: UIActivityIndicatorView
                // 최상단에 이미 IndicatorView가 있는 경우 그대로 사용.
                if let existedView = window.subviews.first(
                    where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                    loadingIndicatorView = existedView
                } else { // 새로 만들기.
                    loadingIndicatorView = UIActivityIndicatorView(style: .large)
                    // 아래는 다른 UI를 클릭하는 것 방지.
                    loadingIndicatorView.frame = window.frame
                    loadingIndicatorView.color = .brown

                    window.addSubview(loadingIndicatorView)
                }
                loadingIndicatorView.startAnimating()
            }
    }
    
    func hideLoading() {
            DispatchQueue.main.async {
                guard let window = UIApplication.shared.windows.last else { return }
                window.subviews.filter({ $0 is UIActivityIndicatorView })
                    .forEach { $0.removeFromSuperview() }
            }
    }
    
    func showAlertAction1(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String = "", message: String = "", completeTitle: String = "확인", _ completeHandler:(() -> Void)? = nil){
                
                guard let currentVc = vc else {
                    completeHandler?()
                    return
                }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
                    
                    let completeAction = UIAlertAction(title: completeTitle, style: .default) { action in
                        completeHandler?()
                        if message == "네트워크 연결상태를 확인 해주세요"{
                            self.exitApp()
                        }
                    }
                    
                    alert.addAction(completeAction)
                    
                    currentVc.present(alert, animated: true, completion: nil)
                }
    }
    
    func exitApp(){
        exit(0)
    }
    
}
