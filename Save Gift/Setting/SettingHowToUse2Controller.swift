//
//  SettingHowToUse2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/06/27.
//

import Foundation
import UIKit

class SettingHowToUse2Controller : UIViewController {
    
    var aIndex : Int = 0
    var aTitle : String? = nil
    var aContentArr : [String] = []
    var descriptionLabel : UILabel = {

        var descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionLabel.textColor = .black
        descriptionLabel.backgroundColor = .white
        descriptionLabel.numberOfLines = 0
        return descriptionLabel

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "\(aTitle!)"
        
        contentArrSetUp()
        labelSetUp()
    }
    
    func labelSetUp(){
        descriptionLabel.text = "\(aContentArr[aIndex])"
        
        //line spacing
        self.descriptionLabel.setTextWithLineHeight(text: descriptionLabel.text, lineHeight: 26)
        self.view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        descriptionLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
//        descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    func contentArrSetUp(){
        
        //기프티콘 수첩이란 0
        aContentArr.append("""
        기프티콘 수첩이란 사진에 저장 되어있는 기프티콘을 앱내에서 저장하고 관리하는 어플리케이션입니다.\n
        기프티콘을 저장하여 관리, 선물, 유효기간 임박 알림을 받아보세요.
        """)
        
        //기능소개 1
        aContentArr.append("""
        기프티콘 저장, 기프티콘 수첩내 친구와 선물, 선물받은 기프티콘 사용 및 관리, 유효기간 임박 알림수신이 있습니다.

        추가적인 기능 요청은
        개발자 이메일을 통해 기능개선 요청 및 추가 요청 해주시기 바랍니다.\n
        개발자 이메일 - krdut1@gmail.com
        """)
        
        //기프티콘 저장은 어떻게 하나요? 2
        aContentArr.append("""
        기프티콘 저장은 앱내 하단 저장소TAB -> 우하단 (+)버튼터치 -> 기프티콘 등록 화면 진입 -> 사진앨범에서 기프티콘 선택 -> 빈칸없이 내용 기입후 기프티콘 등록(저장) -> 저장된 기프티콘 확인
        """)
        
        //기프티콘 선물은 어떻게 하나요? 3
        aContentArr.append("""
        기프티콘 선물은 기본적으로 앱내 저장소TAB에 기프티콘이 저장되어있어야 합니다.

        1. 앱내 저장소TAB -> Unused 기프티콘중 선물하고 싶은 기프티콘 선택 -> 기프티콘 상세화면 진입 -> 하단 기프티콘 선물 터치 -> 기프티콘을 선물할 친구를 선택 -> 선물과 함께 보낼 메시지 작성(작성하지 않아도 됨)-> 선물보내기 터치 -> 선물완료

        2. 앱내 친구TAB -> 친구 목록중 선물하고 싶은 친구를 선택 -> 선물하기(기프티콘) -> 선물할 기프티콘을 선택 -> 선물과 함께 보낼 메시지 작성(작성하지 않아도 됨)-> 선물보내기 터치 -> 선물완료
        """)
        
        //기프티콘 유효기간 알림을 받고싶어요 4
        aContentArr.append("""
        앱내 환경설정TAB -> 알림설정
        알림설정이 체크되어있다면 유효기간 알림설정을 받을수 있습니다.

        또한, 아이폰내 설정 -> 알림 -> 기프티콘 수첩 -> 알림 허용이 허용 되어있는지 확인 바랍니다.
        """)
        
        //사용하지 않은 기프티콘이 앱에서 사라졌어요 5
        aContentArr.append("""
        저장된 기프티콘은 저장한 사용자가 삭제하지 않는 이상 사라지지 않습니다.\n
        만일 사용되지 않은 기프티콘이 사용한 기프티콘 목록에 있다면 사용자가 기프티콘 등록 및 수정한 유효기간이 당일을 넘겨 사용하지 못할때 자동으로 이동됩니다.
        """)
        
        //선물함에 있던 기프티콘이 앱에서 사라졌어요 6
        aContentArr.append("""
        선물함에 있던 기프티콘이 앱에서 사라진 경우는
        선물한 사람이 회수(선물취소)하는 경우 밖에 없습니다.

        선물받은 사람은 선물함에서 기프티콘 사용, 미사용 처리 밖에 못하니 이점 유의하시기 바랍니다.
        """)
        
        //친구추가에서 친구를 찾을수 없어요 7
        aContentArr.append("""
        앱내 친구TAB -> 우상단 친구추가 버튼 -> 가입된 이메일 혹은 가입된 휴대폰 번호로 찾기

        입력된 이메일이나 입력된 휴대폰 번호로 찾을수 없다면 해당 이메일이나 휴대폰번호는 가입되지 않은 정보입니다.
        """)
        
        //앱 업데이트가 필요하다고 나와요 8
        aContentArr.append("""
        업데이트를 하지 않아도 기프티콘 수첩을 이용하실 수 있으시지만 원활한 사용을 위해 업데이트를 권장하고 있습니다. :)
        """)
        
        //내정보 변경을 하고싶어요 9
        aContentArr.append("""
        앱내 환경설정TAB -> 내정보 -> 로그인된 계정의 비밀번호 입력 -> 내정보 변경
        """)
        
        //회원 탈퇴 하고싶어요 10
        aContentArr.append("""
        앱내 환경설정TAB -> 회원탈퇴

        회원탈퇴 하더라도 기프티콘 수첩에서 제공하는 회원가입이 필요하지 않는 서비스는 이전과 같이 사용하실 수 있습니다.

        - 회원탈퇴 시 공유되고 있는 미사용 기프티콘은 선물함에서 사라집니다.
        - 기프티콘 수첩에서 관리 하고있는 기프티콘들은 삭제 됩니다.
        - 회원탈퇴 하더라도 기프티콘을 소유하고 있다면 사용가능 합니다.
        """)
    }
}
