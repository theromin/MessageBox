//
//  RegisterViewController.swift
//  MessageBox
//
//  Created by 王晓敏 on 2020/12/10.
//

import UIKit

class RegisterViewController: UIViewController {
    let idLabel:UILabel! = UILabel(frame: CGRect(x: 40, y: 200, width: 100, height: 50))
    let passwordLabel: UILabel! = UILabel(frame: CGRect(x: 40, y: 280, width: 100, height: 50))
    let idText:UITextField = UITextField(frame: CGRect(x: 130, y: 200, width: 200, height: 50))
    let passwordText:UITextField = UITextField(frame: CGRect(x: 130, y: 280, width: 200, height: 50))
    let submitButton:UIButton = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        idLabel.text = "账号"
        idLabel.font = UIFont.systemFont(ofSize: 24)
        idText.keyboardType = UIKeyboardType.numberPad
        idText.borderStyle = UITextField.BorderStyle.roundedRect
        passwordLabel.text = "密码"
        passwordLabel.font = UIFont.systemFont(ofSize: 24)
        passwordText.isSecureTextEntry = true
        passwordText.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.backgroundColor = UIColor.white
        self.title = "注册"
        self.view.addSubview(idLabel)
        self.view.addSubview(idText)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordText)
        idText.becomeFirstResponder()
        
        submitButton.frame = CGRect(x: 70, y: 380, width: 240, height: 50)
        submitButton.setTitle("提交", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        self.view.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(RegisterViewController.submit), for: .touchUpInside)
    }
    
    @objc func submit(){
        let id:String = idText.text!
        let password:String = passwordText.text!
        
        var tip:UIAlertController!
        var action:UIAlertAction!
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dictionaryPath = documentPath.appending("userList.plist")
        var dicFromPList:NSDictionary? = NSDictionary(contentsOfFile: dictionaryPath)
        
        var users = Dictionary<String,String>()
        if(dicFromPList != nil){
            users = dicFromPList as! [String : String]
        }
//        let plistPath = Bundle.main.path(forResource: "UserList", ofType: "plist")
        
        if id==""||password=="" {
            tip = UIAlertController(title: "提示", message: "账号或密码为空", preferredStyle: UIAlertController.Style.alert)
            action = UIAlertAction(title: "返回", style: UIAlertAction.Style.cancel, handler: nil)
            tip.addAction(action)
        }else if(users[id] != nil){
            tip = UIAlertController(title: "提示", message: "该账号已注册", preferredStyle: UIAlertController.Style.alert)
            action = UIAlertAction(title: "返回", style: UIAlertAction.Style.cancel, handler: nil)
            tip.addAction(action)
            //TODO:
//            action = UIAlertAction(title: "找回密码", style: UIAlertAction.Style.default, handler: nil)
//            tip.addAction(action)
        }else{
            var loginInfo = Dictionary<String,String>()
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let dictionaryPath = documentPath.appending("userList.plist")
            var dicFromPList:NSDictionary? = NSDictionary(contentsOfFile: dictionaryPath)
            if(dicFromPList != nil){
                loginInfo = dicFromPList as! [String : String]
            }
            //保存登陆信息
            loginInfo.updateValue(password, forKey: id)
            dicFromPList = loginInfo as NSDictionary
            let _:Bool = dicFromPList!.write(toFile: dictionaryPath, atomically:true)
            self.view.endEditing(true)
            
            //保存用户信息
            var users:Array<User>
//            var users = Array<User>()
            let homePath:URL={
                let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let doc = docs.first!
                return doc.appendingPathComponent("users.archive")
            }()
            users = (NSKeyedUnarchiver.unarchiveObject(withFile: homePath.path) as? Array<User>)!//TODO:一开始为空文件
            let user:User = User(id: id, nickName: id)
            users.append(user)
            NSKeyedArchiver.archiveRootObject(users, toFile: homePath.path)
            
            tip = UIAlertController(title: "提示", message: "注册成功", preferredStyle: UIAlertController.Style.alert)
            action =  UIAlertAction(title: "返回", style: UIAlertAction.Style.default) { (alters:UIAlertAction) in
                 let userInformation = ["id":id,"password":password]
                 NotificationCenter.default.post(name: NSNotification.Name("RegisterSubmit"), object: nil, userInfo: userInformation)
                 self.navigationController?.popViewController(animated: true)
             }
             tip.addAction(action)
        }
        self.present(tip, animated: true, completion: nil)
    }
    
}
