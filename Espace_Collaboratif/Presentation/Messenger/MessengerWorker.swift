//
//  MessengerWorker.swift
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
import Promises
import SwiftyJSON

class MessengerWorker{
    
    func PostImage(type: String, body: String, user: [String: Any], room: [String: Any], file: String)-> Promise<Messenger1>{
        return RoomAPIClient.posImage(type: type, body: body, user: user, room: room, file: file)
        
    }
    func getRoomsById(id:Int) -> Promise<[Messenger1]>{
    return RoomAPIClient.getRoomById(id: id)
    }
    
    func PostMsg(type: String, file: String, room: [String: Any], user: [String: Any], body: String)-> Promise<Messenger1>{
        return RoomAPIClient.PostMsg(type: type, file: file, room: room, user: user, body: body)
        
    }
    
    func connect(eventBus: EventBus) -> Promise<String> {
        return EventBusApiClientTest.Connect(eventBus: eventBus)
     }
    func send(eventBus: EventBus, body: Dictionary<String,Any>, channel: String) -> Promise<String> {
        return EventBusApiClientTest.Send(eventBus: eventBus, body: body, channel: channel)
        }
     
     func presentMessenger(bodyJson: JSON) -> Promise<Messenger1>{
        return EventBusApiClientTest.presentMessenger(bodyJson: bodyJson)
     }

}
