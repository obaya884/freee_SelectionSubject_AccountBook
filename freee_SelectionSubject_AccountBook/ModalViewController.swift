//
//  ModalViewController.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/05/02.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

protocol AddButtonDelegate {
    func afterPushModalViewAddButton(sectionTag: Int, itemName: String, moneyAmount: Int)
}

class ModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var sectionNameArray: [String] = []
    var delegate: AddButtonDelegate?
    var sectionPickerView: UIPickerView = UIPickerView()
    
    @IBOutlet var sectionTextField: UITextField!
    @IBOutlet var itemNameTextField: UITextField!
    @IBOutlet var moneyAmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        itemNameTextField.delegate = self
        moneyAmountTextField.delegate = self
        sectionTextField.delegate = self
        sectionPickerView.delegate = self
        sectionPickerView.dataSource = self
        sectionPickerView.showsSelectionIndicator = true
        
        //PickerView ToolBar Setings
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ModalViewController.done))
        toolbar.setItems([flexibleItem, doneItem], animated: true)
        
        
        // sectionTextField settings
        self.sectionTextField.inputView = sectionPickerView
        self.sectionTextField.inputAccessoryView = toolbar
        self.sectionTextField.tintColor = .clear
        
        // itemNameTextField Settings
        self.itemNameTextField.returnKeyType = .done
        
        // moneyAmountTextField Settings
        self.moneyAmountTextField.keyboardType = .numbersAndPunctuation
        self.moneyAmountTextField.returnKeyType = .done
        
        // sectionPickerView Initial Setting
        self.sectionPickerView.selectRow(0, inComponent: 0, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //PickerView Title Settings
        sectionNameArray.removeAll()
        
        let userDefaults: UserDefaults = UserDefaults.standard
        sectionNameArray.append(userDefaults.object(forKey: "topLeftSectionName") as! String)
        sectionNameArray.append(userDefaults.object(forKey: "topRightSectionName") as! String)
        sectionNameArray.append(userDefaults.object(forKey: "bottomLeftSectionName") as! String)
        sectionNameArray.append(userDefaults.object(forKey: "bottomRightSectionName") as! String)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //入力フォームのリセット
        self.sectionTextField.text = ""
        self.itemNameTextField.text = ""
        self.moneyAmountTextField.text = ""
        self.sectionPickerView.selectRow(0, inComponent: 0, animated: false)
        
    }
    
    @IBAction func pushAddButton(){
        var flag: Bool = true
        
        //入力検査
        if (sectionTextField.text == ""){
            print("no section")
            sectionTextField.backgroundColor = .red
            flag = false
        }
        if(itemNameTextField.text == ""){
            print("no itemName")
            itemNameTextField.backgroundColor = .red
            flag = false
        }
        if(moneyAmountTextField.text == ""){
            print("no moneyAmount")
            moneyAmountTextField.backgroundColor = .red
            flag = false
        }
        if(moneyAmountTextField.text?.isOnlyNumeric() == false){
            print("invalid input")
            moneyAmountTextField.backgroundColor = .red
            flag = false
        }
        
        //flagがtrue(全て入力されていた)なら
        if (flag){
            var sectionTag: Int = 0
            
            //sectionからtag番号の取得
            for sectionName in sectionNameArray{
                if(sectionTextField.text == sectionName){
                    sectionTag = sectionNameArray.firstIndex(of: sectionName)!
                }
            }
            //入力内容を格納
            let itemName: String = self.itemNameTextField.text!
            let moneyAmount: Int = Int(self.moneyAmountTextField.text!)!

            //入力フォームのリセット
            self.sectionTextField.text = ""
            self.itemNameTextField.text = ""
            self.moneyAmountTextField.text = ""
            self.sectionTextField.backgroundColor = .white
            self.itemNameTextField.backgroundColor = .white
            self.moneyAmountTextField.backgroundColor = .white
            
            self.sectionPickerView.selectRow(0, inComponent: 0, animated: false)
            
            self.dismiss(animated: true, completion: nil)
            print(sectionTag, itemName, moneyAmount)
            print("call delegate")
            self.delegate?.afterPushModalViewAddButton(sectionTag: sectionTag, itemName: itemName, moneyAmount: moneyAmount)
            
        }
    }
    
    
    // MARK:- SectionTextField Settings
    // sectionTextFieldをタップした時、値が入ってなければ初期値を代入
    /// テキストフィールド入力状態前
    ///
    /// - Parameter textField: 対象のテキストフィールド
    /// - Returns: trueで入力可 falseで入力不可
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("テキストフィールド入力状態前")
        if(self.sectionTextField.text == ""){
            self.sectionTextField.text = self.sectionNameArray[0]
        }
        return true
    }
    
    
    // MARK:- itemNameTextField Settings
    // 完了ボタンでキーボードを下げる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.itemNameTextField.resignFirstResponder()
        return true
    }
    
    // MARK:- PickerView Settings
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sectionNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sectionNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sectionTextField.text = sectionNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    @objc func done() {
        self.sectionTextField.endEditing(true)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.sectionTextField.endEditing(true)
//        self.itemNameTextField.endEditing(true)
//
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
