//
//  TodayCalViewController.swift
//  ChubbyBuster
//
//  Created by Roger's Mac on 2017/5/17.
//  Copyright © 2017年 Roger's Mac. All rights reserved.
//

import UIKit
import Foundation

class TodayCalViewController: UIViewController , UIPickerViewDataSource , UIPickerViewDelegate {
    var dataList:[Double] = [0]
    var flg = 0
    var fooddata = String()
    var item = String()
    var textField = [UIButton]()
    var fileNames = "todayCal"
//    let validChar:[String] = ["1","2","3","4","5","6","7","8","9"
//    ]
    let list:Array = ["pizza","icecream","donut","hamburger","hotdog","steak","frenchfries","pancake","chocolate"]
    let cal:Array = ["252","207","452","410","387","823","347","227","160"]
//    let imgName = ["pizza.png","icecream.png","donut.png","hamburger.png","hotdog.png","steak.png","frenchfries.png","pancake.png","chocolate.png"]
let imgName = ["pizza","icecream","donut","hamburger","hotdog","steak","frenchfries","pancake","chocolate"]
    var arrImg:Array<UIImage> = []
    @IBOutlet var showImg: UIImageView!
    
    
    @IBOutlet weak var bys: UITextField!
    
    @IBOutlet weak var displayCal: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet var myView: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var button: UIButton!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
//        let c = myView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 128)
        let c2 = myView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 500)
        c2.identifier = "center"
        c2.isActive = true
        
        myView.layer.cornerRadius = 10
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Save User Data
    func fileName(of title: String) -> String {
        return "\(title).txt"
    }
    let storageURL: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    func fileURL(of title: String) -> URL {
        return self.storageURL.appendingPathComponent(self.fileName(of: title))
    }
    
    func save(title fileName: String) {
        try! self.displayLabel.text?.write(to: self.fileURL(of: fileName), atomically: true, encoding: .utf8)
    }
    
    func remove(title fileName: String,content textField: UITextField) {
        try? FileManager.default.removeItem(at: self.fileURL(of: fileName))
    }

    @IBAction func updateButton(_ sender: UIButton) {
    
            self.save(title: fileNames)
                
            self.showMessage("資料保存成功" , "您今天攝取了 " + self.displayLabel.text! + "大卡")
        
    }

    
    func showMessage(_ text: String , _ m: String) {
        let alertController = UIAlertController(title: text, message: m , preferredStyle: UIAlertControllerStyle.alert )
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    
    }
    //Mark: pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        fooddata = list[row]
        return list[row]
    }
    @IBAction func doneClick(_ sender: Any) {
        let title = list[pickerView.selectedRow(inComponent: 0)]
        button.setTitle(title, for:  .normal)
        displayPickerView(false)
        item = button.title(for:  .normal)!
        let idx = list.index(of: item)!
        self.displayCal.text = cal[idx] + " kcal"
        showImg.image = UIImage(named: item )
    
    }
    @IBAction func addCal(_ sender:UIButton) {
        let currentNumber = Double(self.displayLabel.text ?? "0")!

        if self.bys.hasText == true {
            if Double(self.bys.text ?? "0") != nil{
            
                let s = Double(self.bys.text ?? "0")!
            
                self.displayLabel.text = "\(currentNumber + s)"
                dataList.append(currentNumber + s)
                self.bys.text = nil
                flg += 1
            }
            else{
            self.showMessage("輸入錯誤","請輸入數字")
            }
        }
        else {
                let str = self.displayCal.text ?? "0"
                let str2 = str.components(separatedBy: " kcal")
                let cl = Double(str2[0])
        
                self.displayLabel.text = "\(currentNumber + cl!)"
                dataList.append(currentNumber + cl!)
           flg += 1
        }
        
        
    }
    
    @IBAction func selectClick(_ sender: Any) {
        displayPickerView(true)
    }
    func displayPickerView(_ show: Bool){
        for c2 in view.constraints{
            if c2.identifier == "center"{
                c2.constant = (show) ? -10 :500
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }


    @IBAction func clearButtonClicked(_ sender: UIButton) {
        self.displayLabel.text = "0"
        dataList.removeAll()
        dataList.append(0)
        flg = 0
    
    }
    
    @IBAction func back(_ sender: UIButton){
        let currentText = self.displayLabel.text ?? "0"

        if currentText != "0"{
        flg -= 1
        self.displayLabel.text = "\(dataList[flg])"
        dataList.removeLast()

        }
        
        
    }

}
