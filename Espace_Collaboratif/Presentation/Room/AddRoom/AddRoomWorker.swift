//
//  AddRoomWorker.swift
//  Espace_Collaboratif
//
//  Created by mehdi on 4/29/20.
//  Copyright (c) 2020 mehdi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Promises

class AddRoomWorker
{
    func getUsers() -> Promise<[User]>
    {
        return RoomAPIClient.getUsers()
    }
    
    func AddRoom (name:String , subject:String, user:[String: Any],isPrivate:Bool, users: [Dictionary<String,Any>]) -> Promise<Room1>
    {
        return RoomAPIClient.AddRoom(name: name, subject: subject, user: user, isPrivate: isPrivate, users:users)
        
    }
}
