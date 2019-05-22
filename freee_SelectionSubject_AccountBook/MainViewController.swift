//
//  MainViewController.swift
//  freee_SelectionSubject_AccountBook
//
//  Created by 大林拓実 on 2019/04/28.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit
import LTHRadioButton
import PopupDialog

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // MARK:- Initialization
    
    // アウトレット変数
    @IBOutlet var topLeftSectionNameTextField: UITextField!
    @IBOutlet var topRightSectionNameTextField: UITextField!
    @IBOutlet var bottomLeftSectionNameTextField: UITextField!
    @IBOutlet var bottomRightSectionNameTextField: UITextField!
    
    @IBOutlet var topLeftSectionTableView: UITableView!
    @IBOutlet var topRightSectionTableView: UITableView!
    @IBOutlet var bottomLeftSectionTableView: UITableView!
    @IBOutlet var bottomRightSectionTableView: UITableView!
    
    // 変数
    // モーダルビューのインスタンス
    let modalView = ModalViewController(nibName: "ModalViewController", bundle: nil)
    
    // 制御用
    var tag: Int = 0
    
    // 項目名用
    var itemNameDataArrays: [[String]] = []
    var topLeftSectionItemNameArray: [String] = []
    var topRightSectionItemNameArray: [String] = []
    var bottomLeftSectionItemNameArray: [String] = []
    var bottomRightSectionItemNameArray: [String] = []
    
    // 金額用
    var moneyAmountDataArrays: [[Int]] = []
    var topLeftSectionMoneyAmountArray: [Int] = []
    var topRightSectionMoneyAmountArray: [Int] = []
    var bottomLeftSectionMoneyAmountArray: [Int] = []
    var bottomRightSectionMoneyAmountArray: [Int] = []
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // TableViewのdelegateとdatasource設定
        topLeftSectionTableView.dataSource = self
        topLeftSectionTableView.delegate = self
        topRightSectionTableView.dataSource = self
        topRightSectionTableView.delegate = self
        bottomLeftSectionTableView.dataSource = self
        bottomLeftSectionTableView.delegate = self
        bottomRightSectionTableView.dataSource = self
        bottomRightSectionTableView.delegate = self
        
        
        // ModalViewのdelegate設定
        modalView.delegate = self
        
        // UserDefaultのインスタンス生成
        let userDefaults: UserDefaults = UserDefaults.standard
        
        // TableViewのカスタムセル登録
        self.topLeftSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.topRightSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.bottomLeftSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.bottomRightSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        // SectionNameTextFieldの値を取得
        // 初期値を設定(ユーザーが変更してない場合はこれが取り出される)
        userDefaults.register(defaults: ["topLeftSectionName": "食費",
                                         "topRightSectionName": "日用品",
                                         "bottomLeftSectionName": "交際費",
                                         "bottomRightSectionName": "娯楽費"])
        // UserDefaultから値の読み出し、TextFieldに反映
        self.topLeftSectionNameTextField.text = userDefaults.object(forKey: "topLeftSectionName") as? String
        self.topRightSectionNameTextField.text = userDefaults.object(forKey: "topRightSectionName") as? String
        self.bottomLeftSectionNameTextField.text = userDefaults.object(forKey: "bottomLeftSectionName") as? String
        self.bottomRightSectionNameTextField.text = userDefaults.object(forKey: "bottomRightSectionName") as? String
        
        // itemNameArrayに値を取得
        // 初期値の設定（本番では除く）
        userDefaults.register(defaults:
            ["topLeftSectionItemName": ["朝食", "昼食", "おやつ", "夕食", "飲料", "お菓子"],
             "topRightSectionItemName": ["洗剤", "柔軟剤", "シャンプー", "リンス", "洗顔剤", "化粧水"],
             "bottomLeftSectionItemName": ["デート", "外食", "ライブ", "カラオケ"],
             "bottomRightSectionItemName": ["DVD", "映画", "マンガ", "ラノベ", "グッズ"]
            ])
        // UserDefaultsから値の読み出し
        topLeftSectionItemNameArray = userDefaults.array(forKey: "topLeftSectionItemName") as! [String]
        topRightSectionItemNameArray = userDefaults.array(forKey: "topRightSectionItemName") as! [String]
        bottomLeftSectionItemNameArray = userDefaults.array(forKey: "bottomLeftSectionItemName") as! [String]
        bottomRightSectionItemNameArray = userDefaults.array(forKey: "bottomRightSectionItemName") as! [String]
        
        // 全データ配列作成
        generateItemNameDataArrays()
        
        // moneyAmountArrayに値を取得
        // 初期値の設定（本番では除く）
        userDefaults.register(defaults:
            ["topLeftSectionMoneyAmount": [300, 140, 495, 346, 1244, 452],
             "topRightSectionMoneyAmount": [436, 569, 205, 459, 256, 4369],
             "bottomLeftSectionMoneyAmount": [1355, 5636, 313, 2400],
             "bottomRightSectionMoneyAmount": [5732, 3622, 253, 1251, 346]
            ])
        // UserDefaultsから値の読み出し
        topLeftSectionMoneyAmountArray = userDefaults.array(forKey: "topLeftSectionMoneyAmount") as! [Int]
        topRightSectionMoneyAmountArray = userDefaults.array(forKey: "topRightSectionMoneyAmount") as! [Int]
        bottomLeftSectionMoneyAmountArray = userDefaults.array(forKey: "bottomLeftSectionMoneyAmount") as! [Int]
        bottomRightSectionMoneyAmountArray = userDefaults.array(forKey: "bottomRightSectionMoneyAmount") as! [Int]
        
        // 全データ配列作成
        generateMoneyAmountDataArrays()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.topLeftSectionTableView.flashScrollIndicators()
        self.topRightSectionTableView.flashScrollIndicators()
        self.bottomLeftSectionTableView.flashScrollIndicators()
        self.bottomRightSectionTableView.flashScrollIndicators()
        
    }
    
    // タスク追加ボタン押下時のメソッド(PopupDialogを用いたモーダル表示）
    @IBAction func pushPlusButton(){
        
        // モーダル外のオーバーレイ表示の設定
        let overlayAppearance = PopupDialogOverlayView.appearance()
        overlayAppearance.color           = .white
        overlayAppearance.blurRadius      = 5
        overlayAppearance.blurEnabled     = true
        overlayAppearance.liveBlurEnabled = false
        overlayAppearance.opacity         = 0.2
        
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: modalView, transitionStyle: .zoomIn)
        
        // 作成したポップアップを表示する
        present(popup, animated: true, completion: {() -> Void in
            print("complete")
        })
    }
    
    // データ配列の作成メソッド
    func generateItemNameDataArrays(){
        itemNameDataArrays.removeAll()
        itemNameDataArrays.append(topLeftSectionItemNameArray)
        itemNameDataArrays.append(topRightSectionItemNameArray)
        itemNameDataArrays.append(bottomLeftSectionItemNameArray)
        itemNameDataArrays.append(bottomRightSectionItemNameArray)
    }
    
    func generateMoneyAmountDataArrays(){
        moneyAmountDataArrays.removeAll()
        moneyAmountDataArrays.append(topLeftSectionMoneyAmountArray)
        moneyAmountDataArrays.append(topRightSectionMoneyAmountArray)
        moneyAmountDataArrays.append(bottomLeftSectionMoneyAmountArray)
        moneyAmountDataArrays.append(bottomRightSectionMoneyAmountArray)
    }
    
    // 画面外をタッチした時にキーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // どのtextfield編集に対しても閉じれるようにviewに対してendEditngする
            self.view.endEditing(true)
    }
    
    
    
    // MARK:- TableView Settings
    // tableviewの処理を分岐するメソッド
    func checkTableView(_ tableView: UITableView) -> Void{
        if (tableView.isEqual(topLeftSectionTableView)) {
            tag = 0
        }
        else if (tableView.isEqual(topRightSectionTableView)) {
            tag = 1
        }
        else if (tableView.isEqual(bottomLeftSectionTableView)) {
            tag = 2
        }
        else if (tableView.isEqual(bottomRightSectionTableView)){
            tag = 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkTableView(tableView)
        return itemNameDataArrays[tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        checkTableView(tableView)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        // テキスト反映
        cell.itemNameLabel.text = itemNameDataArrays[tag][indexPath.row]
        cell.moneyAmountLabel.text = "¥" + String(moneyAmountDataArrays[tag][indexPath.row])

        // cell選択時のハイライト解除
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        // cellのdelegate実装先の設定
        cell.delegate = self
        
        return cell
    }
    
    
}

// MARK:- Original Protocol Extentions
extension MainViewController: RadioButtonDelegate{
    func onSelectRadioButton(sender: LTHRadioButton) {
        print("catch delegate")
        let cell = sender.superview?.superview as? CustomTableViewCell
        let tableview = cell?.superview as? UITableView
        
        // UserDefaultsのインスタンス
        let userDefaults: UserDefaults = UserDefaults.standard
        
        if( (tableview?.isEqual(topLeftSectionTableView))! ){
            
            let indexPath = self.topLeftSectionTableView.indexPath(for: cell!)
            
            // 1次データの削除
            self.topLeftSectionItemNameArray.remove(at: indexPath!.row)
            self.topLeftSectionMoneyAmountArray.remove(at: indexPath!.row)
            
            // 2次データ再生成
            // numberOfRowsInSectionではここを見てるから
            // 作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateItemNameDataArrays()
            generateMoneyAmountDataArrays()
            
            // UserDefaultsの保存情報にも変更を反映
            userDefaults.removeObject(forKey: "topLeftSectionItemName")
            userDefaults.set(topLeftSectionItemNameArray, forKey: "topLeftSectionItemName")
            userDefaults.removeObject(forKey: "topLeftSectionMoneyAmount")
            userDefaults.set(topLeftSectionMoneyAmountArray, forKey: "topLeftSectionMoneyAmount")
            
            
            // tableviewの操作
            self.topLeftSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.topLeftSectionTableView.reloadData()
            }
            
        }
        else if( (tableview?.isEqual(topRightSectionTableView))! ){
            let indexPath = self.topRightSectionTableView.indexPath(for: cell!)
            
            // 1次データの削除
            self.topRightSectionItemNameArray.remove(at: indexPath!.row)
            self.topRightSectionMoneyAmountArray.remove(at: indexPath!.row)
            
            
            // 2次データ再生成
            // numberOfRowsInSectionではここを見てるから
            // 作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateItemNameDataArrays()
            generateMoneyAmountDataArrays()
            // UserDefaultsの保存情報にも変更を反映
            userDefaults.removeObject(forKey: "topRightSectionItemName")
            userDefaults.set(topRightSectionItemNameArray, forKey: "topRightSectionItemName")
            userDefaults.removeObject(forKey: "topRightSectionMoneyAmount")
            userDefaults.set(topRightSectionMoneyAmountArray, forKey: "topRightSectionMoneyAmount")
            
            
            // tableviewの操作
            self.topRightSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.topRightSectionTableView.reloadData()
            }
        }
        else if( (tableview?.isEqual(bottomLeftSectionTableView))! ){
            let indexPath = self.bottomLeftSectionTableView.indexPath(for: cell!)
            
            // 1次データの削除
            self.bottomLeftSectionItemNameArray.remove(at: indexPath!.row)
            self.bottomLeftSectionMoneyAmountArray.remove(at: indexPath!.row)
            
            // 2次データ再生成
            // numberOfRowsInSectionではここを見てるから
            // 作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateItemNameDataArrays()
            generateMoneyAmountDataArrays()
            
            // UserDefaultsの保存情報にも変更を反映
            userDefaults.removeObject(forKey: "bottomLeftSectionItemName")
            userDefaults.set(bottomLeftSectionItemNameArray, forKey: "bottomLeftSectionItemName")
            userDefaults.removeObject(forKey: "bottomLeftSectionMoneyAmount")
            userDefaults.set(bottomLeftSectionMoneyAmountArray, forKey: "bottomLeftSectionMoneyAmount")
            
            
            // tableviewの操作
            self.bottomLeftSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.bottomLeftSectionTableView.reloadData()
            }
        }
        else if( (tableview?.isEqual(bottomRightSectionTableView))! ){
            let indexPath = self.bottomRightSectionTableView.indexPath(for: cell!)
            
            // 1次データの削除
            self.bottomRightSectionItemNameArray.remove(at: indexPath!.row)
            self.bottomRightSectionMoneyAmountArray.remove(at: indexPath!.row)
            
            // 2次データ再生成
            // numberOfRowsInSectionではここを見てるから
            // 作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateItemNameDataArrays()
            generateMoneyAmountDataArrays()
            
            // UserDefaultsの保存情報にも変更を反映
            userDefaults.removeObject(forKey: "bottomRightSectionItemName")
            userDefaults.set(bottomRightSectionItemNameArray, forKey: "bottomRightSectionItemName")
            userDefaults.removeObject(forKey: "bottomRightSectionMoneyAmount")
            userDefaults.set(bottomRightSectionMoneyAmountArray, forKey: "bottomRightSectionMoneyAmount")
            
            // tableviewの操作
            self.bottomRightSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.bottomRightSectionTableView.reloadData()
            }
        }
    }
}

extension MainViewController: AddButtonDelegate{
    func afterPushModalViewAddButton(sectionTag: Int, itemName: String, moneyAmount: Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            print("catch delegate")
            print(sectionTag, itemName, moneyAmount)
            
            let userDefaults: UserDefaults = UserDefaults.standard
            
            switch sectionTag {
            case 0:
                self.topLeftSectionItemNameArray.insert(itemName, at: 0)
                self.generateItemNameDataArrays()
                self.topLeftSectionMoneyAmountArray.insert(moneyAmount, at: 0)
                self.generateMoneyAmountDataArrays()
                self.topLeftSectionTableView.beginUpdates()
                self.topLeftSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.topLeftSectionTableView.endUpdates()
                self.topLeftSectionTableView.flashScrollIndicators()
                // UserDefaultsの保存情報にも変更を反映
                userDefaults.removeObject(forKey: "topLeftSectionItemName")
                userDefaults.set(self.topLeftSectionItemNameArray, forKey: "topLeftSectionItemName")
                userDefaults.removeObject(forKey: "topLeftSectionMoneyAmount")
                userDefaults.set(self.topLeftSectionMoneyAmountArray, forKey: "topLeftSectionMoneyAmount")
                
                
            case 1:
                self.topRightSectionItemNameArray.insert(itemName, at: 0)
                self.generateItemNameDataArrays()
                self.topRightSectionMoneyAmountArray.insert(moneyAmount, at: 0)
                self.generateMoneyAmountDataArrays()
                self.topRightSectionTableView.beginUpdates()
                self.topRightSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.topRightSectionTableView.endUpdates()
                self.topRightSectionTableView.flashScrollIndicators()
                // UserDefaultsの保存情報にも変更を反映
                userDefaults.removeObject(forKey: "topRightSectionItemName")
                userDefaults.set(self.topRightSectionItemNameArray, forKey: "topRightSectionItemName")
                userDefaults.removeObject(forKey: "topRightSectionMoneyAmount")
                userDefaults.set(self.topRightSectionMoneyAmountArray, forKey: "topRightSectionMoneyAmount")
                
            case 2:
                self.bottomLeftSectionItemNameArray.insert(itemName, at: 0)
                self.generateItemNameDataArrays()
                self.bottomLeftSectionMoneyAmountArray.insert(moneyAmount, at: 0)
                self.generateMoneyAmountDataArrays()
                self.bottomLeftSectionTableView.beginUpdates()
                self.bottomLeftSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.bottomLeftSectionTableView.endUpdates()
                self.bottomLeftSectionTableView.flashScrollIndicators()
                // UserDefaultsの保存情報にも変更を反映
                userDefaults.removeObject(forKey: "bottomLeftSectionItemName")
                userDefaults.set(self.bottomLeftSectionItemNameArray, forKey: "bottomLeftSectionItemName")
                userDefaults.removeObject(forKey: "bottomLeftSectionMoneyAmount")
                userDefaults.set(self.bottomLeftSectionMoneyAmountArray, forKey: "bottomLeftSectionMoneyAmount")
                
                
            case 3:
                self.bottomRightSectionItemNameArray.insert(itemName, at: 0)
                self.generateItemNameDataArrays()
                self.bottomRightSectionMoneyAmountArray.insert(moneyAmount, at: 0)
                self.generateMoneyAmountDataArrays()
                self.bottomRightSectionTableView.beginUpdates()
                self.bottomRightSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.bottomRightSectionTableView.endUpdates()
                self.bottomRightSectionTableView.flashScrollIndicators()
                // UserDefaultsの保存情報にも変更を反映
                userDefaults.removeObject(forKey: "bottomRightSectionItemName")
                userDefaults.set(self.bottomRightSectionItemNameArray, forKey: "bottomRightSectionItemName")
                userDefaults.removeObject(forKey: "bottomrightSectionMoneyAmount")
                userDefaults.set(self.bottomRightSectionMoneyAmountArray, forKey: "bottomRightSectionMoneyAmount")
                
            default:
                break
            }
        }
    }
}
