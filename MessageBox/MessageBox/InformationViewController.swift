//
//  InformationViewController.swift
//  MessageBox
//
//  Created by 王晓敏 on 2020/12/14.
//

import UIKit

class InformationViewController: UIViewController {
    let idLabel:UILabel = UILabel(frame: CGRect(x: 40, y: 100, width: 100, height: 30))
    let nickNameLabel:UILabel = UILabel(frame: CGRect(x: 40, y: 150, width: 100, height: 30))
    
    let idText:UILabel = UILabel(frame: CGRect(x: 150, y: 100, width: 100, height: 30))
    let nickName:UILabel = UILabel(frame: CGRect(x: 150, y: 150, width: 100, height: 30))
    
    let changePassword:UIButton = UIButton(type: .system)
    let changeNameBtn:UIButton = UIButton(type: .system)
    let logoutBtn:UIButton = UIButton(type: .system)
//    let idText:UITextField = UITextField(frame: CGRect(x: 150, y: 100, width: 200, height: 30))
//    let passwordText:UITextField = UITextField(frame: CGRect(x: 150, y: 150, width: 200, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initThis()
        idLabel.text="用户名"
        nickNameLabel.text="昵称"
        
//        idText.borderStyle = UITextField.BorderStyle.roundedRect
//        passwordText.borderStyle = UITextField.BorderStyle.roundedRect
        changePassword.frame = CGRect(x: 250, y: 100, width: 80, height: 30)
        changePassword.setTitle("修改密码", for: .normal)
        
        changeNameBtn.frame = CGRect(x: 250, y: 150, width: 80, height: 30)
        changeNameBtn.setTitle("修改昵称", for: .normal)
        
        logoutBtn.frame = CGRect(x: 150, y: 250, width: 80, height: 30)
        logoutBtn.setTitle("注销", for: .normal)
        
        self.view.addSubview(idLabel)
        self.view.addSubview(idText)
        self.view.addSubview(nickNameLabel)
        self.view.addSubview(nickName)
//        self.view.addSubview(passwordLabel)
//        self.view.addSubview(passwordText)
        
//        self.view.addSubview(changePassword)
//        self.view.addSubview(changeNameBtn)  //TODO
        changeNameBtn.addTarget(self, action: #selector(InformationViewController.changeNickName), for: .touchUpInside)
        self.view.addSubview(logoutBtn)
        logoutBtn.addTarget(self, action: #selector(InformationViewController.logout), for: .touchUpInside)
    }
    
    func initThis(){
        self.idText.text = id
        var users:Array<User>
        let homePath:URL={
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let doc = docs.first!
            return doc.appendingPathComponent("users.archive")
        }()
        users = (NSKeyedUnarchiver.unarchiveObject(withFile: homePath.path) as? Array<User>)!
        var user:User = User(id: "", nickName: "")
        var flag:Bool = false
        for index in 0..<users.count{
            if(users[index].id == id){
                user = users[index]
                flag = true
            }
        }
        if flag{
            self.nickName.text = user.nickName
        }
//        self.nickName.text = userInformation["id"] as? String
//        self.passwordText.text = userInformation["password"] as? String
        
    }
    
    @objc func changeNickName(){
        var users:Array<User>
        let homePath:URL={
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let doc = docs.first!
            return doc.appendingPathComponent("users.archive")
        }()
        users = (NSKeyedUnarchiver.unarchiveObject(withFile: homePath.path) as? Array<User>)!
        var user:User = User(id: "", nickName: "")
        for index in 0..<users.count{
            if(users[index].id == id){
                user = users[index]
            }
        }
        //写到这  弹出窗口，保存文件
    }
    
    @objc func logout(){
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("Logout"), object: nil, userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
}


