//
//  CustomCell.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/27.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var labelCustom: UILabel!
    @IBOutlet weak var imageviewCustom: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
