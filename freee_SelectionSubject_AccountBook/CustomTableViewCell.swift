//
//  CustomTableViewCell.swift
//  freee_SelectionSubject_AccountBook
//
//  Created by 大林拓実 on 2019/04/29.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit
import LTHRadioButton

protocol RadioButtonDelegate{
    func onSelectRadioButton(sender: LTHRadioButton)
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var radioButton: LTHRadioButton!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var moneyAmountLabel: UILabel!
    
    
    var delegate: RadioButtonDelegate?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        radioButton.selectedColor = UIColor.red
        
        radioButton.onSelect {
            print("call delegate")
            // 処理中のセルを選択不可にする
            self.isUserInteractionEnabled = false
            // radioButtonのセレクトアニメーションが終わったくらいでセル削除処理
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                self.delegate?.onSelectRadioButton(sender: self.radioButton)
            }
        }
        
//        radioButton.onDeselect {
//            self.taskLabel.text = "deselected"
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
