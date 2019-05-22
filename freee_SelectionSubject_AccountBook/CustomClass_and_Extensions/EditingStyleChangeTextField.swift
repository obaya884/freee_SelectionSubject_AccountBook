//
//  EditingStyleChangeEditableTextField.swift
//  freee_SelectionSubject_AccountBook
//
//  Created by 大林拓実 on 2019/05/03.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

class EditingStyleChangeTextField: UITextField, UITextFieldDelegate {
    
    override func awakeFromNib() {
        self.delegate = self
        self.borderStyle = .none
        
        // Keyboard Setting
        self.returnKeyType = .done
    }
    
    /// テキストフィールド入力状態後
    ///
    /// - Parameter textField: 対象のテキストフィールド
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("テキストフィールド入力状態後")
        self.borderStyle = .roundedRect
        self.backgroundColor = .white
    }
    
    /// リターンキー入力時
    ///
    /// - Parameter textField: 対象のテキストフィールド
    /// - Returns: trueでリターン実行 falseでリターンを無視
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("リターン入力時")
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    /// フォーカスが外れる前
    ///
    /// - Parameter textField: 対象のテキストフィールド
    /// - Returns: trueでフォーカスを外す falseでフォーカスを外さない
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("フォーカスが外れる前")
        if(self.text == ""){
            self.backgroundColor = .red
            return false
        }
        else if(tag == 4 && self.text?.isOnlyNumeric() == false){
                self.backgroundColor = .red
                return false
        }
        else{
            // タグごとの処理
            // 0~3: MainView, 4: SummaryView
            let userDefaults: UserDefaults = UserDefaults.standard
            switch tag {
            case 0:
                userDefaults.set(self.text, forKey: "topLeftSectionName")
            case 1:
                userDefaults.set(self.text, forKey: "topRightSectionName")
            case 2:
                userDefaults.set(self.text, forKey: "bottomLeftSectionName")
            case 3:
                userDefaults.set(self.text, forKey: "bottomRightSectionName")
            case 4:
                userDefaults.set(self.text, forKey: "monthlyTargetMoneyAmount")
            default:
                break
            }
        return true
        }
    }
    
    /// フォーカスが外れた後
    ///
    /// - Parameter textField: 対象のテキストフィールド
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("フォーカスが外れた後")
        self.borderStyle = .none
        self.backgroundColor = .clear
        
//        if(tag == 4){
//            let summaryVC = SummaryViewController()
//            summaryVC.setUpMonthlyTargetMoneyAmount()
//            summaryVC.setUpMoneyAmount()
//            summaryVC.setUpPieChartView()
//        }
    }
    
    //範囲外タップでキーボードを下げる
    //→viewcontrollerで実装
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
