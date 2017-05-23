//
//  UserDataViewController.swift
//  ChubbyBuster
//
//  Created by Roger's Mac on 2017/5/17.
//  Copyright © 2017年 Roger's Mac. All rights reserved.
//

import UIKit
import Foundation

class UserDataViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var age: UITextField!
    
    var fileNames = ["userName","height","weight","age"]
    
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields.append(userName)
        textFields.append(height)
        textFields.append(weight)
        textFields.append(age)
        
        self.updateUserData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //讓小鍵盤觸碰空白處彈回去
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for textField in textFields{
                textField.resignFirstResponder()
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
        var index = 0;
        for textField in textFields{
            textField.text = try? String(contentsOf: self.fileURL(of: fileNames[index]), encoding: .utf8)
            index += 1;
        }
    }
    
    func message(_ text: String){
        let alertController = UIAlertController(title: text,message: nil, preferredStyle: .alert)
        //顯示提示框
        self.present(alertController, animated: true, completion: nil)
        //兩秒鐘後消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        var check = true
        for textField in textFields{
            if textField.text == ""{
                check = false
                break
            }
        }
        if check{
            var index = 0;
            for textField in textFields{
                self.save(title: fileNames[index], content: textField)
                index += 1;
            }
            self.message("保存成功!")
        }
        else{
            self.message("保存失敗!請檢查是否有空欄")
        }
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        var index = 0;
        for textField in textFields{
            textField.text = ""
            self.remove(title: fileNames[index], content: textField)
            index += 1;
        }
        self.message("清除成功!")
    }
    
    
    
    
    
    
    

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
