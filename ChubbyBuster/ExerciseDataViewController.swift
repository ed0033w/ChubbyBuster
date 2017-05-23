//
//  ExerciseDataViewController.swift
//  ChubbyBuster
//
//  Created by Roger's Mac on 2017/5/17.
//  Copyright © 2017年 Roger's Mac. All rights reserved.
//

import UIKit

class ExerciseDataViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    var fileNames = "ExerciseData"
    var timedata = String()
    @IBOutlet var myView: UIView!
    let list = ["1 hour at noon","2 hours at noon","4 hours at noon","1 hour at afternoon","2 hours at afternoon","4 hours at afternoon","1 hour at night","2 hours at night","4 hours at night"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var button: UIButton!
    
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
    
    func save(title fileName: String) {
        try! self.displayLabel.text?.write(to: self.fileURL(of: fileName), atomically: true, encoding: .utf8)
    }
    
    func remove(title fileName: String,content textField: UITextField) {
        try? FileManager.default.removeItem(at: self.fileURL(of: fileName))
    }
    
    
    @IBAction func updateButton(_ sender: UIButton) {
        
        self.save(title: fileNames)
        
        self.showMessage("資料保存成功" , "您今天選擇的運動是 " + self.displayLabel.text! + "時段是" + self.timedata)
        
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
        myView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let c = myView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 128)
        c.identifier = "bottom"
        c.isActive = true
        
        myView.layer.cornerRadius = 10
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        timedata = list[row]
        return list[row]
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
        let title = list[pickerView.selectedRow(inComponent: 0)]
        button.setTitle(title, for:  .normal)
        displayPickerView(false)
    }

    @IBAction func selectClick(_ sender: Any) {
        displayPickerView(true)
    }
    func displayPickerView(_ show: Bool){
        for c in view.constraints{
            if c.identifier == "bottom"{
                c.constant = (show) ? -10 :128
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
}
