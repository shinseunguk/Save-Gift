//
//  RegisterUseTableViewCell.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/31.
//

import UIKit

class RegisterUseTableViewCell: UITableViewCell {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
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
        print("빈곳 터치 키보드 내리기 RegisterUseTableViewCell")
        self.superview?.endEditing(true)
    }
    
}
