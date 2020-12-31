//
//  RevertViewController.swift
//  MessageBox
//
//  Created by 王晓敏 on 2020/12/22.
//

import UIKit

class RevertViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

//    var message = Message()!
    var messages:Array<Message> = []
    var message:Message?
    var index:Int?
    
    var users:Array<User> = []
    var user:User?
    
//    let screenRect = UIScreen.main.bounds
    var writerLabel:UILabel!
//    var textLabel:UILabel!
    var textLabel:UITextView!
    var tableView = UITableView()
    
    
    let deleteMessageBtn:UIButton = UIButton(type: .system)
    let combackBtn:UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let homePath:URL={
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let doc = docs.first!
            return doc.appendingPathComponent("users.archive")
        }()
        users = (NSKeyedUnarchiver.unarchiveObject(withFile: homePath.path) as? Array<User>)!
        for index in 0..<users.count{
            if(users[index].id == id){
                user = users[index]
                break
            }
        }
        
        let messagePath:URL={
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let doc = docs.first!
            return doc.appendingPathComponent("messages.archive")
        }()
        messages = (NSKeyedUnarchiver.unarchiveObject(withFile: messagePath.path) as? Array<Message>)!
        NotificationCenter.default.addObserver(self, selector: #selector(getIndex(_:)), name: NSNotification.Name(rawValue:"detail"), object: nil)
//        self.title = "详情"
        let screenRect = UIScreen.main.bounds
//        textLabel = UILabel(frame: CGRect(x: 5, y: 40, width: screenRect.size.width-10, height: 200))
        textLabel = UITextView(frame: CGRect(x: 5, y: 40, width: screenRect.size.width-10, height: 200))
        textLabel.font = UIFont.systemFont(ofSize: 20)
        textLabel.isEditable = false
        textLabel.backgroundColor = .systemYellow
        writerLabel = UILabel(frame: CGRect(x: 5, y: 5, width: screenRect.size.width-10, height: 30))
//        textLabel.text = message!.text + "!!!!!!"
//        textLabel.backgroundColor = .black
//        textLabel.alignmentRectInsets = UIEdgeInsets(top: 0, left: 0, bottom: textLabel.bounds.height, right: textLabel.bounds.width+5)
        self.view.addSubview(textLabel)
        self.view.addSubview(writerLabel)
        
        deleteMessageBtn.frame = CGRect(x: screenRect.size.width-80, y: 250, width: 50, height: 30)
        deleteMessageBtn.setTitle("删除", for: .normal)
        deleteMessageBtn.addTarget(self, action: #selector(RevertViewController.deleteMessage), for: .touchUpInside)
//        deleteMessageBtn.backgroundColor = .black
        
        combackBtn.frame = CGRect(x: screenRect.size.width-150, y: 250, width: 50, height: 30)
        combackBtn.setTitle("回复", for: .normal)
        combackBtn.addTarget(self, action: #selector(RevertViewController.updateComeback), for: .touchUpInside)
        
        self.view.addSubview(combackBtn)
        
        let tableRect = CGRect(x: 5, y: 300, width: screenRect.size.width-10, height: screenRect.size.height-350)
        tableView = UITableView(frame: tableRect)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
    }
    
    @objc func getIndex(_ notifation:Notification){
        let userInformation = notifation.userInfo!
        index = userInformation["index"] as! Int
        message = messages[index!]
        writerLabel.text = (message?.writer.nickName)! + "     " + (message?.time.description)!
        textLabel.text = message?.text
        
        if(message?.writer.id == id){
            self.view.addSubview(deleteMessageBtn)
        }
//        textLabel.text = message.writer.nickName + "     " +  message?.time.description + "\n" + message!.text
//        print(message?.text)
    }
    
    @objc func deleteMessage(){
        messages.remove(at: index!)
        
        let messagePath:URL={
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let doc = docs.first!
            return doc.appendingPathComponent("messages.archive")
        }()
        NSKeyedArchiver.archiveRootObject(messages, toFile: messagePath.path)
        
        self.dismiss(animated: true, completion: nil)
        let sender = ["flag":1,"index":index] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name("DoDelete"), object: nil, userInfo: sender)
    }
    
    @objc func updateComeback(){
        var messageText:UITextField?
        let tip = UIAlertController(
            title: "回复", message: "请输入",
            preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: nil)
        let yes = UIAlertAction(title: "回复", style: UIAlertAction.Style.default){
            [self](action) -> Void in
            if messageText?.text == "" {
                let alter = UIAlertController(title: "提示", message: "内容为空", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(
                    title: "重新输入", style: UIAlertAction.Style.default, handler:{_ in self.present(tip, animated: true, completion: nil)
                    }
                )
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
            else{
                
                message?.reverts.append(Revert(writer: user!, text: (messageText?.text)!, time: Date()))
                updateMessage()
//                newMessage = Message(writer: id, text: messageText?.text, time: date, reverts: Array<Revert>())
            }
        }
        tip.addTextField { (message) in
            messageText = message
            messageText!.placeholder = "输入回复信息"
        }
        tip.addAction(cancel)
        tip.addAction(yes)
        self.present(tip, animated: true, completion: nil)
    }
    
    func updateMessage(){
        let messagePath:URL={
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let doc = docs.first!
            return doc.appendingPathComponent("messages.archive")
        }()
        NSKeyedArchiver.archiveRootObject(messages, toFile: messagePath.path)
        
        tableView.insertRows(at: [IndexPath(row: (message?.reverts.count)!-1, section: 0)], with: UITableViewRowAnimation.right
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (message?.reverts.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "messageCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
            
        }
        cell?.textLabel?.text = "#" + (indexPath.row+1).description + "   " + message!.reverts[indexPath.row].text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: message!.reverts[indexPath.row].time)
        cell?.detailTextLabel?.text = message!.reverts[indexPath.row].writer.nickName + "      @" + date
        return cell!
    }
    
}
