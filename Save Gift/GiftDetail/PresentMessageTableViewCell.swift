//
//  PresentMessageTableViewCell.swift
//  Save Gift
//
//  Created by mac on 2022/05/30.
//

import UIKit

class PresentMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        print("빈곳 터치 키보드 내리기 \(#file)")
        self.superview?.endEditing(true)
    }
}
