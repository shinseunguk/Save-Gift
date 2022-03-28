//
//  GetDeivceModel.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/20.
//

import Foundation
import UIKit

class GetDeviceModel: UIViewController{
    ///Identifier 찾기

        static func getDeviceIdentifier() -> String {

            var systemInfo = utsname()

            uname(&systemInfo)

            let machineMirror = Mirror(reflecting: systemInfo.machine)

            let identifier = machineMirror.children.reduce("") { identifier, element in

                guard let value = element.value as? Int8, value != 0 else { return identifier }

                return identifier + String(UnicodeScalar(UInt8(value)))

            }

            

            return identifier

        }

        

        /**

         디바이스 모델 (iPhone, iPad) 이름 전달 (iPhone6, iPhone7 Plus...)

         */

        static func deviceModelName() -> String {

            

            let model = UIDevice.current.model

            

            switch model {

            case "iPhone":

                return self.iPhoneModel()

            case "iPad":

                return self.iPadModel()

            case "iPad mini" :

                return self.iPadMiniModel()

            default:

                return "Unknown Model : \(model)"

            }

            

        }

        

        /**

         iPhone 모델 이름 (iPhone6, iPhone7 Plus...)

         */

        static func iPhoneModel() -> String {

            

            let identifier = self.getDeviceIdentifier()

            

            switch identifier {

            case "iPhone1,1" :

                return "iPhone"

            case "iPhone1,2" :

                return "iPhone3G"

            case "iPhone2,1" :

                return "iPhone3GS"

            case "iPhone3,1", "iPhone3,2", "iPhone3,3" :

                return "iPhone4"

            case "iPhone4,1" :

                return "iPhone4s"

            case "iPhone5,1", "iPhone5,2" :

                return "iPhone5"

            case "iPhone5,3", "iPhone5,4" :

                return "iPhone5c"

            case "iPhone6,1", "iPhone6,2" :

                return "iPhone5s"

            case "iPhone7,2" :

                return "iPhone6"

            case "iPhone7,1" :

                return "iPhone6 Plus"

            case "iPhone8,1" :

                return "iPhone6s"

            case "iPhone8,2" :

                return "iPhone6s Plus"

            case "iPhone8,4" :

                return "iPhone SE"

            case "iPhone9,1", "iPhone9,3" :

                return "iPhone7"

            case "iPhone9,2", "iPhone9,4" :

                return "iPhone7 Plus"

            case "iPhone10,1", "iPhone10,4" :

                return "iPhone8"

            case "iPhone10,2", "iPhone10,5" :

                return "iPhone8 Plus"

            case "iPhone10,3", "iPhone10,6" :

                return "iPhoneX"

            default:

                return "\(identifier)"

            }

        }

        

        /**

         iPad 모델 이름

        */

        static func iPadModel() -> String {

            

            let identifier = self.getDeviceIdentifier()

            

            switch identifier {

            case "iPad1,1":

                return "iPad"

            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4" :

                return "iPad2"

            case "iPad3,1", "iPad3,2", "iPad3,3" :

                return "iPad 3rd Generation"

            case "iPad3,4", "iPad3,5", "iPad3,6" :

                return "iPad 4rd Generation"

            case "iPad4,1", "iPad4,2", "iPad4,3" :

                return "iPad Air"

            case "iPad5,3", "iPad5,4" :

                return "iPad Air2"

            case "iPad6,7", "iPad6,8" :

                return "iPad Pro 12.9"

            case "iPad6,3", "iPad6,4" :

                return "iPad Pro 9.7"

            case "iPad6,11", "iPad6,12" :

                return "iPad 5th Generation"

            case "iPad7,1", "iPad7,2" :

                return "iPad Pro 12.9 2nd Generation"

            case "iPad7,3", "iPad7,4" :

                return "iPad Pro 10.5"

            case "iPad7,5", "iPad7,6" :

                return "iPad 6th Generation"

            default:

                return "\(identifier)"

            }

        }

        

        /**

         iPad mini 모델 이름

         */

        static func iPadMiniModel() -> String {

            

            let identifier = self.getDeviceIdentifier()

            

            switch identifier {

            case "iPad2,5", "iPad2,6", "iPad2,7" :

                return "iPad mini"

            case "iPad4,4", "iPad4,5", "iPad4,6" :

                return "iPad mini2"

            case "iPad4,7", "iPad4,8", "iPad4,9" :

                return "iPad mini3"

            case "iPad5,1", "iPad5,2" :

                return "iPad mini4"

            default:

                return "Unknown iPad mini : \(identifier)"

            }

        }
}

