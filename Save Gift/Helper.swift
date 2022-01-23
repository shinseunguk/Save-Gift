//
//  Helper.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/23.
//

import Foundation


class Helper {
    
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
    
}
