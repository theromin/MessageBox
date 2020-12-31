//
//  ViewController.swift
//  MessageBox
//
//  Created by 王晓敏 on 2020/12/9.
//

import UIKit

class LoginViewController: UIViewController {
    //标签、输入框、按钮
    let idLabel:UILabel! = UILabel(frame: CGRect(x: 40, y: 200, width: 100, height: 50))
    let passwordLabel: UILabel! = UILabel(frame: CGRect(x: 40, y: 280, width: 100, height: 50))
    let idText:UITextField = UITextField(frame: CGRect(x: 130, y: 200, width: 200, height: 50))
    let passwordText:UITextField = UITextField(frame: CGRect(x: 130, y: 280, width: 200, height: 50))
    let loginButton:UIButton = UIButton(type: .system)
    
    var user = Dictionary<String,String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(autoFillInfo(_:)), name: NSNotification.Name(rawValue:"RegisterSubmit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout(_:)), name: NSNotification.Name(rawValue:"Logout"), object: nil)
        
        idLabel.text = "账号"
        idLabel.font = UIFont.systemFont(ofSize: 24)
        idText.keyboardType = UIKeyboardType.numberPad
        idText.borderStyle = UITextField.BorderStyle.roundedRect
        passwordLabel.text = "密码"
        passwordLabel.font = UIFont.systemFont(ofSize: 24)
        passwordText.isSecureTextEntry = true
        passwordText.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.backgroundColor = UIColor.white
        self.title = "登录"
        self.view.addSubview(idLabel)
        self.view.addSubview(idText)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordText)
        
        loginButton.frame = CGRect(x: 70, y: 380, width: 240, height: 50)
        loginButton.setTitle("登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        self.view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(LoginViewController.login), for: .touchUpInside)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItem.Style.plain, target: self, action: #selector(LoginViewController.register))
    }
    @objc func register(){
        let viewController = RegisterViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func logout(_ notifation:Notification){
        passwordText.text = ""
        passwordText.becomeFirstResponder()
    }
    
    @objc func autoFillInfo(_ notifation:Notification){
        let userInformation = notifation.userInfo!
        id = userInformation["id"] as? String
        idText.text = id
        passwordText.text = ""
        passwordText.becomeFirstResponder()
    }
    
    @objc func login(){
        //打开plist
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dictionaryPath = documentPath.appending("userList.plist")
        let dicFromPList:NSDictionary? = NSDictionary(contentsOfFile: dictionaryPath)
        if(dicFromPList != nil){
            self.user = dicFromPList as! [String : String]
//            for key in self.user.keys{
//                print("==========")
//                print(key)
//                print(user[key]!)
//            }
        }
//        print(self.user.count)

        id = idText.text!
        let password:String = passwordText.text!
        var tip:UIAlertController!
        var action:UIAlertAction!
        if(id==""||password==""){
            tip = UIAlertController(title: "提示", message: "账号密码为空", preferredStyle: UIAlertController.Style.alert)
            action = UIAlertAction(title: "重新输入", style: UIAlertAction.Style.default, handler: nil)
            tip.addAction(action)
            self.present(tip, animated: true, completion: nil)
        }else if(user[id!] != password){//TODO:账号不存在，去注册
            tip = UIAlertController(title: "提示", message: "账号密码错误", preferredStyle: UIAlertController.Style.alert)
            action = UIAlertAction(title: "重新输入", style: UIAlertAction.Style.default, handler: nil)
            tip.addAction(action)
            self.present(tip, animated: true, completion: nil)
        }else{
            self.view.endEditing(true)
            
            let tabViewController = UITabBarController()
            let informationViewController = InformationViewController()
            let messageViewController = MessageViewController()
            let messageNavigationController = UINavigationController(rootViewController: messageViewController)
            
            
            tabViewController.viewControllers = [informationViewController,messageNavigationController]
            let tabBar = tabViewController.tabBar
            let informationItem = tabBar.items![0]
            informationItem.title = " 我的"
            informationItem.image = UIImage(named: "mine")
            let messageItem = tabBar.items![1]
            messageItem.title = "留言板"
            messageItem.image = UIImage(named: "category")
//            let userInfomation = ["id":id,"password":password]
            tabViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(tabViewController, animated: true, completion: nil)
//            NotificationCenter.default.post(name: NSNotification.Name("LoginSubmit"), object: nil, userInfo: userInfomation)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NotificationCenter.default.removeObserver(self)
    }
}

