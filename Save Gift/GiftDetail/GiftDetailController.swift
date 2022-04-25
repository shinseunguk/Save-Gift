//
//  GiftDetailController.swift
//  Save Gift
//
//  Created by mac on 2022/04/07.
//
// https://shimjifam.tistory.com/101 ------------> v28ue 세팅값

import Foundation
import UIKit

import FirebaseStorage
import Firebase

class GiftDetailControoler : UIViewController{
    
    @IBOutlet weak var vBrandLabel: UILabel!
    @IBOutlet weak var vProductLabel: UILabel!
    @IBOutlet weak var vExpirationLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageExpandBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var presentBtn: UIButton!
    @IBOutlet weak var useynBtn: UIButton!
    
    let localUrl : String = "".getLocalURL()
    
    let categoryArr = ["바코드 번호", "교환처", "상품명", "유효기간", "쿠폰상태", "등록일", "등록자"]
    var contentArr =  ["", "", "", "", "", "", ""]
//    var contentArr : [Any] = []
    
    let calendar = Calendar.current
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    let helper : Helper = Helper()
    
    let nowBrightness : CGFloat = UIScreen.main.brightness;
    
    var daysCount:Int = 0

    var imageUrl : String? = nil
    var seq : Int? = nil
    
    var param : Dictionary<String, Any> = [:]
    var dic : Dictionary<String, Any> = [:]
    
    var brandName : String? = nil
    var productName : String? = nil
    var expirationPeriod : String? = nil
    
    

    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("imageUrl --- > ", "".getLocalURL()+"/images/\(imageUrl!)")
        print("seq --- > ", seq!)
        
        Init()
        viewLabelSetup()
        setupLayout()
//        calculateDays()
        tableView.allowsSelection = false
        
    }
    
    func viewLabelSetup(){
        vBrandLabel.text = brandName
        vProductLabel.text = productName
        vExpirationLabel.text = "유효기간 : \(expirationPeriod!)"
    }
    
    func Init(){
        param["seq"] = seq
        let url = URL(string: "".getLocalURL()+"/images/\(imageUrl!)")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
        
        requestPost(requestUrl: "/gift/detail", param: param)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIScreen.main.brightness = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIScreen.main.brightness = nowBrightness
    }
    
    func setupLayout(){
        imageExpandBtn.layer.cornerRadius = 5
        editBtn.layer.cornerRadius = 5
        presentBtn.layer.cornerRadius = 5
        useynBtn.layer.cornerRadius = 5
    }
    
    @IBAction func imageExpandAction(_ sender: Any) {
        print("imageExpandAction")
    }
    
    @IBAction func editAction(_ sender: Any) {
        actionSheetAlert(title: "기프티콘 편집하기", content1: "기프티콘 삭제", content2: "기프티콘 수정")
    }
    
    @IBAction func presentAction(_ sender: Any) {
        actionSheetAlert(title: "기프티콘 선물하기", content1: "기프티콘 공유", content2: "기프티콘 선물")
    }
    
    @IBAction func useynAction(_ sender: Any) {
        normalAlertUseYn(title: "알림", message: "사용완료 처리 하시겠습니까?")
    }
    
    func actionSheetAlert(title: String, content1: String, content2: String){
        let alert =  UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: content1, style: .default) {
            (action) in print("content1")
        }

        let camera =  UIAlertAction(title: content2, style: .default) {
            (action) in print("content2")
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func normalAlertUseYn(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler : nil)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func requestPost(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
        print("param.... ", param)
        let paramData = try! JSONSerialization.data(withJSONObject: param)
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
                        print("An error has occured: \(e.localizedDescription)")
                        return
                    }

                var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("GiftDetail responseString \n", responseString!)
                    print("/gift/detail data ----> \n", data! as Any)
                    print("/gift/detail response ----> \n", response! as Any)
                    
                    var responseStringA = responseString as! String
                    print("responseStringA ===> ", responseStringA)
//
                    if responseStringA.count != 2{

                        responseStringA = responseStringA.replacingOccurrences(of: "]", with: "")
                        responseStringA = responseStringA.replacingOccurrences(of: "[", with: "")

                        print("responseStringA ---- > \n",responseStringA)

                        let arr = responseStringA.components(separatedBy: "},")
                        print("arr0 --->", arr[0])

                        self.dic = self.helper.jsonParser7(stringData: arr[0] as! String, data1: "barcode_number", data2: "brand", data3: "product_name", data4: "expiration_period", data5: "use_yn", data6:"registration_date", data7: "registrant");

                        print("self.dic ----> \n", self.dic)

                        DispatchQueue.main.async {
                            
                            self.contentArr[0] = self.dic["barcode_number"] as! String
                            self.contentArr[1] = self.dic["brand"] as! String
                            self.contentArr[2] = self.dic["product_name"] as! String
                            self.contentArr[3] = self.dic["expiration_period"] as! String
                            
                            if self.dic["use_yn"] as! Int == 1{
                                self.contentArr[4] = "사용완료"
                            }else {
                                self.contentArr[4] = "사용불가"
                            }
                            
                            self.contentArr[5] = self.dic["registration_date"] as! String
                            self.contentArr[6] = self.dic["registrant"] as! String
                            
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            
                            self.tableView.register(UINib(nibName: "GiftDetailBarcodeTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftDetailBarcodeTableViewCell")
                            self.tableView.register(UINib(nibName: "GiftDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftDetailTableViewCell")
                        }
                        
                    }
                    //서버통신후 getGifty
                    DispatchQueue.main.async {
//                        self.getGifty()
                    }
                }
                // POST 전송
                task.resume()
    }
    
}

extension GiftDetailControoler : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GiftDetailTableViewCell") as! GiftDetailTableViewCell
        
        print("dic 1-> ", dic)
        
        
        cell.copyBtn.layer.cornerRadius = 5
        cell.copyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.copyBtn.titleLabel?.font = .systemFont(ofSize: 14)
        
        cell.copyBtn.addTarget(self, action: #selector(normalAlert), for: .touchUpInside)
        
//        btn.titleLabel?.font = .systemFont(ofSize: 12)
    
        // 바코드번호 클립보드저장 버튼
        if indexPath.row != 0 {
            cell.copyBtn.isHidden = true
        }
        if indexPath.row != 3{
            cell.dDayLabel.isHidden = true
        }
        
//        if indexPath.row == 3{
//            calculateDays(availableDate: contentArr[3])
//        }
        
        //미사용, 사용 set Color
        if indexPath.row == 4{
            if contentArr[4] == "사용가능"{
                cell.secondLabel.textColor = UIColor.systemGreen
            }else if contentArr[4] == "사용불가"{
                cell.secondLabel.textColor = UIColor.red
            }
        }else {
            cell.secondLabel.textColor = UIColor.black
        }
        
        
        cell.firstLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        if indexPath.row == 3{
            let resultDDay : Int = calculateDays(availableDate: contentArr[3])
            if resultDDay == 0 {
                cell.dDayLabel.textColor = UIColor.systemBlue
                cell.dDayLabel.text = "(오늘까지)"
            }else if resultDDay > 0 {
                cell.dDayLabel.textColor = UIColor.red
                cell.dDayLabel.text = "(D+\(resultDDay))"
                contentArr[4] = "사용불가"
            }else if resultDDay < 0 {
                cell.dDayLabel.textColor = UIColor.systemGreen
                cell.dDayLabel.text = "(D-\(resultDDay))"
            }
        }
        cell.firstLabel.text = categoryArr[indexPath.row]
        cell.secondLabel.text = contentArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
    
    func calculateDays(availableDate : String) -> Int {
        print("calculateDays ",availableDate)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: availableDate) // 유효기간
        daysCount = days(date: startDate!, date1: helper.formatDateToday())
        
        print("daysCount ", daysCount)
        return daysCount
    }
    
    func days(date: Date, date1 : String) -> Int {
        
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd" //데이터 포멧 설정
        let dateString = formatter.string(from: date) //문자열로 바꾸기
        
        let dateInt1 : Int = Int(date1.replacingOccurrences(of: "-", with: ""))!
        let dateInt2 : Int = Int(dateString.replacingOccurrences(of: "-", with: ""))!
        
        print("date1Int1 -----> 오늘    날짜 -->", dateInt1)
        print("date1Int2 -----> 유효기간 날짜 -->", dateInt2)
        
//        print("date2 ", date1)
//        print("dateString ", dateString)
//        print("current ", currentDate)
        
        if dateInt1 == dateInt2 {
            return 0
        }else if dateInt1 > dateInt2 {
            print("dateInt1 > dateInt2")
            return calendar.dateComponents([.day], from: date, to: currentDate).day! + 1
        }else if dateInt1 < dateInt2 {
            print("dateInt1 < dateInt2") // 오늘날짜 < 유효기간 날짜
            if calendar.dateComponents([.day], from: date, to: currentDate).day! == 0 {
                return 1
            }else {
               return -calendar.dateComponents([.day], from: date, to: currentDate).day!
            }
        }
        
        return calendar.dateComponents([.day], from: date, to: currentDate).day!
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Void
    {
        print("startDate ", startDate)
        print("endDate ", endDate)
        
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        print("components --------> ", components)
    }
    
    @objc func normalAlert(){
        let alert = UIAlertController(title: "알림", message: "바코드 번호가\n 클립보드에 복사되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}
