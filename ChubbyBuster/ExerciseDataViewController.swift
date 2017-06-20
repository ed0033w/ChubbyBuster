//
//  ExerciseDataViewController.swift
//  ChubbyBuster
//
//  Created by Roger's Mac on 2017/5/17.
//  Copyright © 2017年 Roger's Mac. All rights reserved.
//

import UIKit

class ExerciseDataViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    var begintime_filename = "begintime"
    var endtime_filename = "endtime"
    var sport_filename = "sport"
    var timedata = String()
    var timedata2 = String()
    var check : Int = 0
    @IBOutlet var myView: UIView!
    @IBOutlet var sportView: UIView!
    @IBOutlet weak var showImg: UIImageView!
    
    //let list = ["0:00","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
    let list = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    var list_minute = ["00","01","02","03","04","05","06","07","08","09","10"]
    
    var list_sport = ["badminton","bike","basketball","jogging","soccer","boxing","swim","gym","ping-pong"]
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var sportPickerView: UIPickerView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button_end: UIButton!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    
    
    @IBAction func numericButtonClicked(_ sender: UIButton) {
        
        let numericButtonDigit = sender.tag - 1000
        
        
        
        
        if(numericButtonDigit == 1){
            self.displayLabel.text = "badminton"}
        else if(numericButtonDigit == 2){
            self.displayLabel.text = "bike"}
        else if(numericButtonDigit == 3){
            self.displayLabel.text = "basketball"}
        else if(numericButtonDigit == 4){
            self.displayLabel.text = "jogging"}
        else if(numericButtonDigit == 5){
            self.displayLabel.text = "soccer"}
        else if(numericButtonDigit == 6){
            self.displayLabel.text = "boxing"}
        else if(numericButtonDigit == 7){
            self.displayLabel.text = "swim"}
        else if(numericButtonDigit == 8){
            self.displayLabel.text = "gym"}
        else if(numericButtonDigit == 9){
            self.displayLabel.text = "ping-pong"}
        
        
        
    }
    //save exercise
    func fileName(of title: String) -> String {
        return "\(title).txt"
    }
    let storageURL: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    func fileURL(of title: String) -> URL {
        return self.storageURL.appendingPathComponent(self.fileName(of: title))
    }
    
    func save_time(title fileName: String,content btn: UIButton) {
        try! btn.currentTitle?.write(to: self.fileURL(of: fileName), atomically: true, encoding: .utf8)
    }
    func save_sport(title fileName: String) {
        try! displayLabel.text?.write(to: self.fileURL(of: fileName), atomically: true, encoding: .utf8)
    }
    
    func remove(title fileName: String,content textField: UITextField) {
        try? FileManager.default.removeItem(at: self.fileURL(of: fileName))
    }
    
    
    @IBAction func updateButton(_ sender: UIButton) {
        
        //self.save(title: )
        
        if(button.currentTitle! != "開始時間" && button_end.currentTitle! != "結束時間" && displayLabel.text! != "點我選擇"){
            self.showMessage("資料保存成功" , "您今天選擇的運動是 " + self.displayLabel.text! + "\n時段是 " + self.timedata + " 到 " + self.timedata2)
            self.save_sport(title: sport_filename)
            self.save_time(title: begintime_filename, content: button)
            self.save_time(title: endtime_filename, content: button_end)
        }else{
            self.showMessage("資料保存失敗" , "請檢查運動是否決定及格式是否正確")

        }
        
        
        
    }
    func showMessage(_ text: String , _ m: String) {
        let alertController = UIAlertController(title: text, message: m , preferredStyle: UIAlertControllerStyle.alert )
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let c = myView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 800)
        c.identifier = "bottom"
        c.isActive = true
        
        myView.layer.cornerRadius = 10
        
        view.addSubview(sportView)
        sportView.translatesAutoresizingMaskIntoConstraints = false
        sportView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        sportView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        sportView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let c2 = sportView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 800)
        c2.identifier = "sport"
        c2.isActive = true
        
        sportView.layer.cornerRadius = 10

        
        
        super.viewWillAppear(animated)
        
        for i in 11...59 {
            list_minute.append("\(i)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 2
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            if(component == 0){
                return list.count
            }
            return list_minute.count
        }
        return list_sport.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            if(component == 0){
                return list[row]
            }
            return list_minute[row]
        }
        return list_sport[row]
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let fullScreenSize = UIScreen.main.bounds.size
        return (fullScreenSize.width-20)/2
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func doneClick(_ sender: Any) {
        let title = list[pickerView.selectedRow(inComponent: 0)] + ":" + list_minute[pickerView.selectedRow(inComponent: 1)]
        if(check == 1){
            button.setTitle(title, for:  .normal)
            timedata = button.currentTitle!
        }
        if(check == 2){
            button_end.setTitle(title, for:  .normal)
            timedata2 = button_end.currentTitle!
        }
        
        displayPickerView(false)
    }
    @IBAction func doneSportClick(_ sender: Any) {
        let title = list_sport[sportPickerView.selectedRow(inComponent: 0)]
        self.displayLabel.text = title
        showImg.image = UIImage(named: title )
        displaySportPickerView(false)
        
    }
    
    @IBAction func selectClick(_ sender: Any) {
        displayPickerView(true)
        check = 1
    }
    @IBAction func selectEndClick(_ sender: Any) {
        displayPickerView(true)
        check = 2
    }
    func displayPickerView(_ show: Bool){
        for c in view.constraints{
            if c.identifier == "bottom"{
                c.constant = (show) ? 100 :800
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func selectSportClick(_ sender: Any) {
        displaySportPickerView(true)
    }
    
    func displaySportPickerView(_ show: Bool){
        for c2 in view.constraints{
            if c2.identifier == "sport"{
                c2.constant = (show) ? 100 :800
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }

}
