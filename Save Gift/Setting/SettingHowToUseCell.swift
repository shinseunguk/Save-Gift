//
//  SettingHowToUseCell.swift
//  Save Gift
//
//  Created by mac on 2022/06/21.
//

import UIKit

class SettingHowToUseCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //셀 radius
        self.contentView.layer.cornerRadius = 10
//
//
//        // Your border code here (set border to contentView)
        self.contentView.layer.borderColor = UIColor.systemGray2.cgColor
        self.contentView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
    }
    
}
