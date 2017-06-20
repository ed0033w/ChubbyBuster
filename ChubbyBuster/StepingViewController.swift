//
//  StepingViewController.swift
//  ChubbyBuster
//
//  Created by Roger's Mac on 2017/5/17.
//  Copyright © 2017年 Roger's Mac. All rights reserved.
//
import UIKit
import CoreMotion

class StepingViewController:
    
UIViewController {
    //顯示數據
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var BMILabel: UILabel!
    
    let motionManager = CMMotionManager()
    
    var cal: Int=0
    var acc: Double=0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getGyroData(_:)), userInfo: nil, repeats: true);
        
        updateUserData()
        
    }
    
    func getGyroData(_ sender: Any) {
        //設備支援
        guard motionManager.isGyroAvailable else {
            self.textView.text = "\n此裝置不支援\n"
            return
        }
        
        //數據取得
        self.motionManager.startGyroUpdates()
        if let gyroData = self.motionManager.gyroData {
            let rotationRate = gyroData.rotationRate
            var text = "當前所有數據\n"
            text += "x: \(rotationRate.x)\n"
            text += "y: \(rotationRate.y)\n"
            text += "z: \(rotationRate.z)\n"
            acc=sqrt(rotationRate.x*rotationRate.x+rotationRate.y*rotationRate.y+rotationRate.z*rotationRate.z)
            text += "acc: \(acc)\n"
            if rotationRate.z > 0.1 {
                if acc < 0.15 {
                    text += "正在靜止中\n"
                }
                else if acc < 0.5 {
                    cal=cal+12
                    text += "緩慢移動中\n"
                }
                else if acc < 1 {
                    cal=cal+19
                    text += "正在行走中\n"
                }
                else if acc < 1.5 {
                    cal=cal+317
                    text += "慢速跑步中\n"
                }
                else if acc < 2 {
                    cal=cal+52
                    text += "有氧運動中\n"
                }
                else if acc < 3 {
                    cal=cal+108
                    text += "劇烈運動中\n"
                }
                else {
                    text += "交通工具代步中\n"
                }
            }
            else{
                text += "正在靜止中\n"
            }
            text += "一般常用單位：千卡\n目前使用單位：卡\n"
            text += "已經消耗卡路里: \(cal)\n"
            self.textView.text = text
        }
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
    
    func save(title fileName: String,content textField: UITextField) {
        try! textField.text?.write(to: self.fileURL(of: fileName), atomically: true, encoding: .utf8)
    }
    
    func remove(title fileName: String,content textField: UITextField) {
        try? FileManager.default.removeItem(at: self.fileURL(of: fileName))
    }
    
    func updateUserData() {
        let username = try? String(contentsOf: self.fileURL(of: "userName"), encoding: .utf8)
        if username != nil {
            welcomeLabel.text =  "Hi! " + username! + " 歡迎您"
        }else{
            welcomeLabel.text =  "未登入"
        }
        
        
        let weightString = try? String(contentsOf: self.fileURL(of: "weight"), encoding: .utf8)
        var weight : Double?
        weight = Double(weightString!)

        let heightString = try? String(contentsOf: self.fileURL(of: "height"), encoding: .utf8)
        var height : Double?
        height = Double(heightString!)
        
        if(weight != nil && height != nil){
            let BMI = weight!/((height!/100)*(height!/100))
            BMILabel.text = "您的BMI為 \(BMI)"
        }else{
            BMILabel.text = "身高體重讀取錯誤"
        }
        
    }
    
    
    
    @IBAction func cleanButton(_ sender: UIButton) {
        cal=0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(_ animated: Bool) {
        if self.timer != nil {
            self.timer?.invalidate()
        }
    }
}

