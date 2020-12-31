//
//  Model.swift
//  MessageBox
//
//  Created by 王晓敏 on 2020/12/20.
//

import Foundation

class User:NSObject,NSCoding,NSSecureCoding{
    var id:String
    var nickName:String
    
    func encode(with coder: NSCoder) {
        coder.encode(id,forKey: "id")
        coder.encode(nickName,forKey: "nickName")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as! String
        nickName = coder.decodeObject(forKey: "nickName") as! String
    }
    
    static var supportsSecureCoding: Bool{
        return true
    }
    
    init(id:String,nickName:String){
        self.id = id
        self.nickName = nickName
    }
}

class Revert:NSObject,NSCoding,NSSecureCoding{
    var writer:User
    var text:String
    var time:Date
    
    func encode(with coder: NSCoder) {
        coder.encode(writer,forKey: "writer")
        coder.encode(text,forKey: "text")
        coder.encode(time,forKey: "time")
    }
    
    required init?(coder: NSCoder) {
        writer = coder.decodeObject(forKey: "writer") as! User
        text = coder.decodeObject(forKey: "text") as! String
        time = coder.decodeObject(forKey: "time") as! Date
    }
    
    static var supportsSecureCoding: Bool{
        return true
    }
    
    init(writer:User,text:String,time:Date){
        self.writer = writer
        self.text = text
        self.time = time
    }
}

class Message:NSObject,NSCoding,NSSecureCoding{
    var writer:User
    var text:String
    var time:Date
    var reverts:Array<Revert>

    func encode(with coder: NSCoder) {
        coder.encode(writer,forKey: "writer")
        coder.encode(text,forKey: "text")
        coder.encode(time,forKey: "time")
        coder.encode(reverts,forKey: "reverts")
    }
    
    required init?(coder: NSCoder) {
        writer = coder.decodeObject(forKey: "writer") as! User
        text = coder.decodeObject(forKey: "text") as! String
        time = coder.decodeObject(forKey: "time") as! Date
        reverts = coder.decodeObject(forKey: "reverts") as! Array<Revert>
    }
    
    static var supportsSecureCoding: Bool{
        return true
    }
    
    init(writer:User,text:String,time:Date,reverts:Array<Revert>){
        self.writer = writer
        self.text = text
        self.time = time
        self.reverts = reverts
    }
    
//    override init() {
//
//    }
}
