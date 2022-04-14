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
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageExpandBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var presentBtn: UIButton!
    @IBOutlet weak var useynBtn: UIButton!
    
    let categoryArr = ["바코드 번호", "교환처", "상품명", "유효기간", "쿠폰상태", "등록일", "등록자"]
    var contentArr =  ["1234567890123", "호식이두마리치킨", "후라이드+양념치킨+500ml", "2022-04-09", "사용가능", "2022-04-08", "ghdrlfehd@naver.com(홍길동)"]
    
    let calendar = Calendar.current
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    let helper : Helper = Helper()
    
    var daysCount:Int = 0
    
    

    override func viewDidLoad(){
        super.viewDidLoad()
        
        //test url https://firebasestorage.googleapis.com/v0/b/save-gift-e3710.appspot.com/o/bhc.jpg?alt=media&token=54938b56-88bf-4a0f-acc4-98222e1412ac
//        Storage.storage().reference(forURL: "gs://save-gift-e3710.appspot.com/bhc.jpg").downloadURL { (url, error) in
//            let data = NSData(contentsOf: url!)
//            let image = UIImage(data: data! as Data)
//            self.imageView.image = image
//        }
        
        //https://firebasestorage.googleapis.com/v0/b/save-gift-e3710.appspot.com/o/candy.png?alt=media&token=4fc9190b-1ac1-451a-a40f-c7a12be44de9
        
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/save-gift-e3710.appspot.com/o/bhc.jpg?alt=media&token=54938b56-88bf-4a0f-acc4-98222e1412ac")!
//        if let data = try? Data(contentsOf: url) {
        imageView.image = UIImage(data: try! Data(contentsOf: url))
//        }
        
        setupLayout()
//        calculateDays()
        tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: "GiftDetailBarcodeTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftDetailBarcodeTableViewCell")
        tableView.register(UINib(nibName: "GiftDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftDetailTableViewCell")
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
}

extension GiftDetailControoler : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GiftDetailTableViewCell") as! GiftDetailTableViewCell
        
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
        let alert = UIAlertController(title: "알림", message: "바코드 번호가 클립보드에 복사되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}
