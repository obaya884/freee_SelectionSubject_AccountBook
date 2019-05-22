//
//  SummaryViewController.swift
//  freee_SelectionSubject_AccountBook
//
//  Created by 大林拓実 on 2019/05/21.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit
import Charts

class SummaryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var monthlyTargetMoneyAmountTextField: EditingStyleChangeTextField!
    
    @IBOutlet var pieChartView: PieChartView!
    @IBOutlet var topLeftSectionNameLabel: UILabel!
    @IBOutlet var topRightSectionNameLabel: UILabel!
    @IBOutlet var bottomLeftSectionNameLabel: UILabel!
    @IBOutlet var bottomRightSectionNameLabel: UILabel!
    
    @IBOutlet var topLeftSectionMoneyAmountLabel: UILabel!
    @IBOutlet var topRightSectionMoneyAmountLabel: UILabel!
    @IBOutlet var bottomLeftSectionMoneyAmountLabel: UILabel!
    @IBOutlet var bottomRightSectionMoneyAmountLabel: UILabel!
    @IBOutlet var monthlyBalenceLabel: UILabel!
    
    var monthlyTargetMoneyAmount: Int = 0 // 目標金額
    var monthlyBalance: Int = 0 // 残金
    
    var sectionNameArray: [String] = [] // 費目名の配列
    var sectionMoneyAmountArray: [Double] = [] //費目での合計金額の+目標金額までの残金

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        monthlyTargetMoneyAmountTextField.keyboardType = .numbersAndPunctuation
        monthlyTargetMoneyAmountTextField.returnKeyType = .done
        
        setUpMonthlyTargetMoneyAmount()
        setUpSectionName() // 費目名の読み出し,view反映
        setUpMoneyAmount() // 費目ごとの合計金額計算,view反映
        setUpPieChartView() // グラフ作成
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpMonthlyTargetMoneyAmount()
        setUpSectionName() // 費目名の読み出し
        setUpMoneyAmount() // 費目ごとの合計金額計算
        setUpPieChartView() // グラフ作成
    }
    
    func setUpMonthlyTargetMoneyAmount(){
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["monthlyTargetMoneyAmount": "80000"])
        monthlyTargetMoneyAmount = Int(userDefaults.object(forKey: "monthlyTargetMoneyAmount") as! String)!
        monthlyTargetMoneyAmountTextField.text = String(monthlyTargetMoneyAmount)
    }
    
    func setUpMoneyAmount(){
        var topLeftSectionMoneyAmountArray: [Int] = []
        var topRightSectionMoneyAmountArray: [Int] = []
        var bottomLeftSectionMoneyAmountArray: [Int] = []
        var bottomRightSectionMoneyAmountArray: [Int] = []
        
        let userDefaults: UserDefaults = UserDefaults.standard
        topLeftSectionMoneyAmountArray = userDefaults.array(forKey: "topLeftSectionMoneyAmount") as! [Int]
        topRightSectionMoneyAmountArray = userDefaults.array(forKey: "topRightSectionMoneyAmount") as! [Int]
        bottomLeftSectionMoneyAmountArray = userDefaults.array(forKey: "bottomLeftSectionMoneyAmount") as! [Int]
        bottomRightSectionMoneyAmountArray = userDefaults.array(forKey: "bottomRightSectionMoneyAmount") as! [Int]
        
        var topLeftsectionMoneyAmount: Int = 0
        var topRightsectionMoneyAmount: Int = 0
        var bottomLeftsectionMoneyAmount: Int = 0
        var bottomRightsectionMoneyAmount: Int = 0
        
        for moneyAmount in topLeftSectionMoneyAmountArray {
            topLeftsectionMoneyAmount += moneyAmount
        }
        for moneyAmount in topRightSectionMoneyAmountArray {
            topRightsectionMoneyAmount += moneyAmount
        }
        for moneyAmount in bottomLeftSectionMoneyAmountArray {
            bottomLeftsectionMoneyAmount += moneyAmount
        }
        for moneyAmount in bottomRightSectionMoneyAmountArray {
            bottomRightsectionMoneyAmount += moneyAmount
        }
        
        monthlyBalance = monthlyTargetMoneyAmount - topLeftsectionMoneyAmount - topRightsectionMoneyAmount - bottomLeftsectionMoneyAmount - bottomRightsectionMoneyAmount
        
        topLeftSectionMoneyAmountLabel.text = "¥" + String(topLeftsectionMoneyAmount)
        topRightSectionMoneyAmountLabel.text = "¥" + String(topRightsectionMoneyAmount)
        bottomLeftSectionMoneyAmountLabel.text = "¥" + String(bottomLeftsectionMoneyAmount)
        bottomRightSectionMoneyAmountLabel.text = "¥" + String(bottomRightsectionMoneyAmount)
        monthlyBalenceLabel.text = "¥" + String(monthlyBalance)
        
        sectionMoneyAmountArray.removeAll()
        sectionMoneyAmountArray.append(Double(topLeftsectionMoneyAmount))
        sectionMoneyAmountArray.append(Double(topRightsectionMoneyAmount))
        sectionMoneyAmountArray.append(Double(bottomLeftsectionMoneyAmount))
        sectionMoneyAmountArray.append(Double(bottomRightsectionMoneyAmount))
        sectionMoneyAmountArray.append(Double(monthlyBalance))
        
    }
    
    func setUpSectionName(){
        sectionNameArray.removeAll()
        let userDefaults: UserDefaults = UserDefaults.standard
        sectionNameArray.append(userDefaults.object(forKey: "topLeftSectionName") as! String)
        sectionNameArray.append(userDefaults.object(forKey: "topRightSectionName") as! String)
        sectionNameArray.append(userDefaults.object(forKey: "bottomLeftSectionName") as! String)
        sectionNameArray.append(userDefaults.object(forKey: "bottomRightSectionName") as! String)
        sectionNameArray.append("残額")
        
    }
    
    func setUpPieChartView() {
        
        self.pieChartView.chartDescription?.enabled = false // グラフの説明を非表示
        self.pieChartView.legend.enabled = false // グラフの注釈を非表示
        self.pieChartView.drawEntryLabelsEnabled = true // グラフ上にデータラベルを表示
        self.pieChartView.rotationEnabled = false // グラフを固定
        self.pieChartView.highlightPerTapEnabled = false // タップ時のハイライトを無効化
        
        // 円グラフに表示するデータ
        var dataEntries: [ChartDataEntry] = Array()
        
        if(monthlyBalance < 0){
            for index in 0...3 {
                dataEntries.append(PieChartDataEntry(value: sectionMoneyAmountArray[index], label: sectionNameArray[index]))
            }
        }
        else{
            for index in 0...4 {
                dataEntries.append(PieChartDataEntry(value: sectionMoneyAmountArray[index], label: sectionNameArray[index]))
            }
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "ラベル")
        dataSet.valueTextColor = .black
        dataSet.valueFont = UIFont(name: "HiraginoSans-W6", size: 14)!
        if(monthlyBalance < 0){
            dataSet.setColors(UIColor(red: 250/255, green: 141/255, blue: 98/255, alpha: 0.8),
                              UIColor(red: 164/255, green: 202/255, blue: 188/255, alpha: 0.8),
                              UIColor(red: 172/255, green: 189/255, blue: 120/255, alpha: 0.8),
                              UIColor(red: 234/255, green: 180/255, blue: 100/255, alpha: 0.8))
        }
        else{
            dataSet.setColors(UIColor(red: 250/255, green: 141/255, blue: 98/255, alpha: 0.8),
                              UIColor(red: 164/255, green: 202/255, blue: 188/255, alpha: 0.8),
                              UIColor(red: 172/255, green: 189/255, blue: 120/255, alpha: 0.8),
                              UIColor(red: 234/255, green: 180/255, blue: 100/255, alpha: 0.8),
                              UIColor(red: 218/255, green: 227/255, blue: 243/255, alpha: 1.0))
        }
        
        let chartData = PieChartData(dataSet: dataSet)
        
        self.pieChartView.data = chartData
    }
    
    // 画面外をタッチした時にキーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // どのtextfield編集に対しても閉じれるようにviewに対してendEditngする
        self.view.endEditing(true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
