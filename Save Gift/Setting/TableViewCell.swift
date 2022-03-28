//
//  TableViewCell.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Turn off all switches first
        uiSwitch.isOn = true
    }
    @IBAction func changeSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn {
            print("on")
        } else {
            print("off")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
