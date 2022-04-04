//
//  Helper.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/23.
//

import Foundation
import UIKit

class Helper : UIViewController{
    
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
        formatter.dateFormat = "yyyyMMddHHmm" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        
        return str
    }
    
}
