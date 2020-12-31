//
//  MessageViewController.swift
//  MessageBox
//
//  Created by 王晓敏 on 2020/12/19.
//

import UIKit

class MessageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    var users:Array<User> = []
    var user:User?
    var newMessage:Message?
    var messages:Array<Message> = []
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initThis()
        self.title = "留言板"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MessageViewController.addMessage))
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteMessage(_:)), name: NSNotification.Name(rawValue:"DoDelete"), object: nil)
    }
    func initThis(){
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
        
        let screenRect = UIScreen.main.bounds
        let tableRect = CGRect(x: 5, y: 20, width: screenRect.size.width-10, height: screenRect.size.height-20)
        tableView = UITableView(frame: tableRect)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    
    @objc func addMessage(){
        var messageText:UITextField?
        let tip = UIAlertController(
            title: "添加", message: "请输入留言信息",
            preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: nil)
        let yes = UIAlertAction(title: "添加", style: UIAlertAction.Style.default){
            [self](action) -> Void in
            if messageText?.text == "" {
                let alter = UIAlertController(title: "提示", message: "留言为空", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(
                    title: "重新输入", style: UIAlertAction.Style.default, handler:{_ in self.present(tip, animated: true, completion: nil)
                    }
                )
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
            else{
                newMessage = Message(writer: user!, text: (messageText?.text)!, time: Date(), reverts: Array<Revert>())
                updateMessage()
//                newMessage = Message(writer: id, text: messageText?.text, time: date, reverts: Array<Revert>())
            }
        }
        tip.addTextField { (message) in
            messageText = message
            messageText!.placeholder = "输入留言信息"
        }
        tip.addAction(cancel)
        tip.addAction(yes)
        self.present(tip, animated: true, completion: nil)
    }
    
    func updateMessage(){
        messages.insert(newMessage!, at: 0)
//            .append(newMessage!)
        let messagePath:URL={
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let doc = docs.first!
            return doc.appendingPathComponent("messages.archive")
        }()
        NSKeyedArchiver.archiveRootObject(messages, toFile: messagePath.path)

        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right
        )
        
//        for index in 0..<messages.count{
//            print("=====")
//            print(messages[index].writer.id)
//            print("=====")
//            print(messages[index].writer.nickName)
//            print("=====")
//            print(messages[index].text)
//            print("=====")
//            print(messages[index].time)
//            print("=====")
//        }
    }
    
    @objc func deleteMessage(_ notifation:Notification){
        let userInformation = notifation.userInfo!
        let index = userInformation["index"] as! Int
//        print("============")
//        print(IndexPath(row: index, section: 0).description)
        messages.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.left)
        
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.insert{
//
//        }
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "messageCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
            
        }
        cell?.textLabel?.text = messages[indexPath.row].text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: messages[indexPath.row].time)
        cell?.detailTextLabel?.text = messages[indexPath.row].writer.nickName + "      @" + date
        //TODO:用户在messages里只要存个id，通过users中查找nickname
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("==========")
        let viewController = RevertViewController()
        self.present(viewController, animated: true, completion: nil)
        let messageIndex = ["flag":1,"index":indexPath.row]
//        print(indexPath.description)
//        print("=============")
        NotificationCenter.default.post(name: NSNotification.Name("detail"), object: nil, userInfo: messageIndex)
//        self.navigationController?.pushViewController(viewController, animated: true)
    }


//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count*2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell:UITableViewCell?
//        var cellForWriter:UITableViewCell?
//        if (indexPath as NSIndexPath).row%2 == 0{
//            cellForWriter = tableView.dequeueReusableCell(withIdentifier: "writerCell")
//            if cellForWriter == nil{
//                cellForWriter = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "writerCell")
//            }
//            cellForWriter?.textLabel?.text = messages[(indexPath as NSIndexPath).row/2].writer.nickName + " " + messages[(indexPath as NSIndexPath).row/2].time.description
//            cellForWriter?.textLabel?.font = UIFont.systemFont(ofSize: 16)
//        }
//        else{
//            cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")
//            if cell == nil{
//            }
//        }
//
//        return cell
//    }
}
