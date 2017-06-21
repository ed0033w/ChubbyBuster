//
//  StepingViewController.swift
//  ChubbyBuster
//
//  Created by Roger's Mac on 2017/5/17.
//  Copyright © 2017年 Roger's Mac. All rights reserved.
//
import UIKit
import CoreMotion

class StepingViewController : UIViewController {
    //顯示數據
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var BMILabel: UILabel!
    
    let motionManager = CMMotionManager()
    
    var cal: Int=0
    var level: Int=1
    var movelevel: Int=0
    var exp: Int=0
    var levelrequire: Int=0
    var acc: Double=0
    var timer: Timer?
   
    var fileNames = ["Cal","Lev","Exp"]

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.getGyroData(_:)), userInfo: nil, repeats: true);
        
        updateUserData()
        
    }
    
    func getGyroData(_ sender: Any) {
    
        //取
        
        let NowCal = try? String(contentsOf: self.fileURL(of: "Cal"), encoding: .utf8)
        let NowLev = try? String(contentsOf: self.fileURL(of: "Lev"), encoding: .utf8)
        let NowExp = try? String(contentsOf: self.fileURL(of: "Exp"), encoding: .utf8)
        if (NowCal != nil) {
            cal = Int(NowCal!)!
        }
        if (NowLev != nil) {
            level = Int(NowLev!)!
        }
        if (NowExp != nil) {
            exp = Int(NowExp!)!
        }

        
        //設備支援
        guard motionManager.isGyroAvailable else {
            self.textView.text = "\n此裝置不支援\n"
            return
        }
        
        //數據取得
        self.motionManager.startGyroUpdates()
        if let gyroData = self.motionManager.gyroData {
            let rotationRate = gyroData.rotationRate
            var text = "當前狀態\n"
            text += "目前等級: \(level)\n"
            //text += "運動狀態: \(exp)\n"
            //text += "x: \(rotationRate.x)\n"
            //text += "y: \(rotationRate.y)\n"
            //text += "z: \(rotationRate.z)\n"
            acc=sqrt(rotationRate.x*rotationRate.x+rotationRate.y*rotationRate.y+rotationRate.z*rotationRate.z)
            //text += "acc: \(acc)\n"
            if rotationRate.z*rotationRate.z > 0.05 {
                if acc < 0.15 {
                    cal=cal+0
                    exp=exp+0
                    text += "正在靜止中\n"
                    movelevel=1
                }
                else if acc < 0.8 {
                    cal=cal+42
                    exp=exp+100
                    text += "緩慢移動中\n"
                    movelevel=2
                }
                else if acc < 1.5 {
                    cal=cal+61
                    exp=exp+200
                    text += "正在行走中\n"
                    movelevel=3
                }
                else if acc < 2.0 {
                    cal=cal+138
                    exp=exp+300
                    text += "慢速跑步中\n"
                    movelevel=4
                }
                else if acc < 3.8 {
                    cal=cal+215
                    exp=exp+400
                    text += "有氧運動中\n"
                    movelevel=5
                }
                else if acc < 5.0 {
                    cal=cal+351
                    exp=exp+500
                    text += "劇烈運動中\n"
                    movelevel=6
                }
                else if acc < 8.0 {
                    cal=cal+751
                    exp=exp+600
                    text += "超劇烈運動中\n"
                    movelevel=7
                }
                else {
                    cal=cal+0
                    exp=exp+0
                    text += "交通工具代步中\n"
                    movelevel=8
                }
            }
            else{
                text += "正在靜止中\n"
            }
            let TodayCal = try? String(contentsOf: self.fileURL(of: "todayCal"), encoding: .utf8)
            
            if TodayCal != nil {
                 text +=  "今日攝取卡路里：" + TodayCal! + "\n"
            }else{
                 text +=  "今日攝取未知卡路里\n"
            }
            text += "已經消耗卡路里: \(cal/1000)\n"
            text += "(目前使用單位：大卡)\n"
            text += "已經累積經驗值: \(exp)\n"
           
            levelrequire=level*level*500
            if(exp>levelrequire){
                level=level+1
                exp=exp-levelrequire
            }

            text += "目標經驗值: \(levelrequire)\n"
            
            self.textView.text = text
        
            //存
            text = "\(cal)"
            try! text.write(to: self.fileURL(of: "Cal"), atomically: true, encoding: .utf8)
            text = "\(level)"
            try! text.write(to: self.fileURL(of: "Lev"), atomically: true, encoding: .utf8)
            text = "\(exp)"
            try! text.write(to: self.fileURL(of: "Exp"), atomically: true, encoding: .utf8)
            
        
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
        var weight : Double? = nil
        if (weightString != nil) {
            weight = Double(weightString!)
        }

        let heightString = try? String(contentsOf: self.fileURL(of: "height"), encoding: .utf8)
        var height : Double? = nil
        if (heightString != nil) {
            height = Double(heightString!)
        }

        if(weight != nil && height != nil){
            let BMI = weight!/((height!/100)*(height!/100))
            BMILabel.text = "您的BMI為 \(BMI)"
        }else{
            BMILabel.text = "身高體重讀取錯誤"
        }
        
        let Mysport = try? String(contentsOf: self.fileURL(of: "sport"), encoding: .utf8)
 
        if Mysport != nil {
            sportLabel.text =  "您選擇的運動是：" + Mysport!
        }else{
            sportLabel.text =  "未輸入"
        }
        let Begin = try? String(contentsOf: self.fileURL(of: "begintime"), encoding: .utf8)
        let End = try? String(contentsOf: self.fileURL(of: "endtime"), encoding: .utf8)
        
        if (Begin != nil) && (End != nil) {
            timeLabel.text =  "開始時間：" + Begin! + " " + "結束時間：" + End!
        }else{
            timeLabel.text =  "未輸入時間\n"
        }

        
    }
    
    //背景執行
    override func viewWillDisappear(_ animated: Bool) {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.getGyroData(_:)), userInfo: nil, repeats: true)
        //  assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    @IBAction func cleanButton(_ sender: UIButton) {
        cal=0
        level=0
        exp=0
        var text2 = "\(cal)"
        try! text2.write(to: self.fileURL(of: "Cal"), atomically: true, encoding: .utf8)
        text2 = "\(level)"
        try! text2.write(to: self.fileURL(of: "Lev"), atomically: true, encoding: .utf8)
        text2 = "\(exp)"
        try! text2.write(to: self.fileURL(of: "Exp"), atomically: true, encoding: .utf8)
        
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

