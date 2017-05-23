//
//  TodayCalViewController.swift
//  ChubbyBuster
//
//  Created by Roger's Mac on 2017/5/17.
//  Copyright © 2017年 Roger's Mac. All rights reserved.
//

import UIKit
import Foundation

class TodayCalViewController: UIViewController {
    var dataList:[Double] = [0]
    var flg = 0
    var textField = [UIButton]()
    var fileNames = "todayCal"
    
    @IBOutlet weak var displayLabel: UILabel!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
    @IBAction func numericButtonClicked(_ sender: UIButton) {
        
        let numericButtonDigit = sender.tag
        let currentNumber = Double(self.displayLabel.text ?? "0")!
        let digitText = "\(numericButtonDigit)"
        let result = currentNumber + Double(numericButtonDigit)

        let currentText = self.displayLabel.text ?? "0"
        if currentText == "0" {
            
            self.displayLabel.text = digitText
        }
        else {
            self.displayLabel.text = "\(result)"
            
        }
        dataList.append(result)
        flg += 1
        

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
