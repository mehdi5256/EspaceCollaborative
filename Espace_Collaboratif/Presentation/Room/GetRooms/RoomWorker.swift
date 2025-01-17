//
//  RoomWorker.swift
//  Espace_Collaboratif
//
//  Created by mehdi on 4/24/20.
//  Copyright (c) 2020 mehdi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Promises

class RoomWorker
{
    func getRooms(token:String) -> Promise<[Room1]>
    {
        return RoomAPIClient.getRooms(token : token)
    }
}


