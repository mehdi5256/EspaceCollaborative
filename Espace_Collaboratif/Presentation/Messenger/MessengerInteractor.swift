//
//  MessengerInteractor.swift
//  Espace_Collaboratif
//
//  Created by mehdi on 4/30/20.
//  Copyright (c) 2020 mehdi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MessengerBusinessLogic
{
    func postImage(type: String, body: String, user: [String: Any], room: [String: Any], file: String)
    func getRoomById (id:Int)
    func PostMsg(type: String, file: String, room: [String: Any], user: [String: Any], body: String)
    
    func connect()
    func registerMessenger(id:Int)
    func send(idroom: Int, messagesend:String,type:String,file:String)
    func sendReaction(idroom: Int, type: String, reaction: Reaction1)
    
    func GetRoomEventBusid(id:Int)
}

protocol MessengerDataStore
{
    //var name: String { get set }
}

class MessengerInteractor: MessengerBusinessLogic, MessengerDataStore
{
    func connect() {
        eventbus = EventBus(host: Keys.MobileIntegrationServer.baseURLEventBus , port: Keys.MobileIntegrationServer.basePortEventBus)
        
        worker = MessengerWorker()
        
        worker?.connect(eventBus: eventbus).then {
            result in
            self.presenter?.presentConnexionSuccess(result: result)
        }.catch { error in
            self.presenter?.presentError(error: error.localizedDescription)
            print("got error")
        }
    }
    func send(idroom: Int, messagesend:String,type:String,file:String) {
        
        var body : Dictionary<String,Any> = ["type":type,
                                             "file":file,
                                             "user_id":UserDefaultLogged.idUD,
                                             "room_id":idroom ]
        body["body"] = messagesend
        
        worker?.send(eventBus: eventbus, body: body, channel:"chat.to.server").then {
            result in
            self.presenter?.sendMessageEventBus(result: result)
        }.catch { error in
            self.presenter?.presentError(error: error.localizedDescription)
            print("got error")
        }
    }
    
    func sendReaction(idroom: Int, type: String, reaction: Reaction1) {
        
        
        var body : Dictionary<String,Any> = ["type":type,"user_id":UserDefaultLogged.idUD,
                                             "room_id":idroom,
                                             "message_id":reaction.message?.id]
        body["body"] = reaction.type
        
        worker?.send(eventBus: eventbus, body: body, channel:"chat.to.server").then {
            result in
            self.presenter?.sendMessageEventBus(result: result)
        }.catch { error in
            self.presenter?.presentError(error: error.localizedDescription)
            print("got error")
        }
        
    }
    
    func registerMessenger(id:Int){
        let _ = try! eventbus.register(address: "chat.to.client/\(id)") {
            
            
            if $0.body["type"].description == "TEXT" || $0.body["type"].description == "IMAGE" || $0.body["type"].description == "SONDAGE"  {
                self.worker?.presentMessenger(bodyJson: $0.body["body"] ).then {
                    messageQuestion in
                    self.presenter?.presentMessenger(messenger: messageQuestion)
                    
                    print(messageQuestion)
                }.catch { error in
                    self.presenter?.presentError(error: error.localizedDescription )
                }
                
            }
            else if $0.body["type"].description == "VOTE" {
                
                let messageId = $0.body["message_id"].description
                let ChoixId = $0.body["choix_id"].description
                
                let jsonData = $0.body["user"].description.data(using: .utf8)!
                do {
                    let UserObj = try JSONDecoder().decode(User.self, from: jsonData)
                    self.presenter?.presentVoteEventBus(idMessage: messageId,idChoix: ChoixId, user:UserObj)
                    
                } catch let error as NSError {
                    
                    print(error)
                    
                }
                
                
            }
            else if $0.body["type"].description == "REACTION" {
                
                let messageId = $0.body["message_id"].description
                
                self.worker?.presentReaction(bodyJson: $0.body["body"], messageId : Int(messageId)!).then {
                    reaction in
                    
                    self.presenter?.presentReaction(reaction: reaction,messageId:Int(messageId)!)
                    
                    
                }.catch { error in
                    self.presenter?.presentError(error: error.localizedDescription )
                    
                }
            }
            
        }
    }
    
    
    func GetRoomEventBusid(id: Int) {
        worker = MessengerWorker()
        worker?.getRoomEventBus(id: id).then {
            roomdid in
            print(roomdid)
            self.presenter?.presentGetRoomEventBusSuccess(id: roomdid)
        }.catch {
            error in
            self.presenter?.presentGetRoomByIdError(error: error.localizedDescription)
        }
    }
    
    
    var presenter: MessengerPresentationLogic?
    var worker: MessengerWorker?
    //var name: String = ""
    var eventbus: EventBus!
    
    // MARK: Do something
    
    func getRoomById(id: Int) {
        worker = MessengerWorker()
        worker?.getRoomsById(id: id).then {
            roomdid in
            print(roomdid)
            self.presenter?.presentGetRoomByIdSuccess(roomdid: roomdid)
        }.catch {
            error in
            self.presenter?.presentGetRoomByIdError(error: error.localizedDescription)
        }
    }
    
    
    
    func PostMsg(type: String, file: String, room: [String: Any], user: [String: Any], body: String) {
        worker = MessengerWorker()
        worker?.PostMsg(type: type, file: file, room: room, user: user, body: body).then {
            msg in
            print(msg)
            
            self.presenter?.presentPostMsgdSuccess(msg: [msg])
        }.catch {
            error in
            self.presenter?.presentPostMsgdError(error: error.localizedDescription)
        }
        
        
        
    }
    
    func postImage(type: String, body: String, user: [String : Any], room: [String : Any], file: String) {
        worker = MessengerWorker()
        worker?.PostImage(type: type, body: body, user: user, room: room, file: file).then {
            img in
            print(img)
            
            self.presenter?.presentPostImgdSuccess(img: [img])
        }.catch {
            error in
            self.presenter?.presentPostImgError(error: error.localizedDescription)
        }
    }
    
}


