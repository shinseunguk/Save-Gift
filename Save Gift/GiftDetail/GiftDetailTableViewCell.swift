//
//  GiftDetailTableViewCell.swift
//  Save Gift
//
//  Created by mac on 2022/04/08.
//

import UIKit

class GiftDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var dDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = secondLabel.text!
        print("secondLabel", secondLabel.text!)
    }
}
