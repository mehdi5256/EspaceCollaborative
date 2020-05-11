//
//  RoomInteractor.swift
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

protocol RoomBusinessLogic
{
  func doSomething(request: Room.Something.Request)
    func getRooms()

}

protocol RoomDataStore
{
  //var name: String { get set }
}

class RoomInteractor: RoomBusinessLogic, RoomDataStore
{
    var presenter: RoomPresentationLogic?
    var worker: RoomWorker?
    //var name: String = ""
    var room: Room1!

    
    // MARK: Do something
    
     func doSomething(request: Room.Something.Request)
     {
       worker = RoomWorker()
       
       let response = Room.Something.Response()
       presenter?.presentSomething(response: response)
     }
    
    func getRooms() {
          worker = RoomWorker()
              worker?.getRooms().then {
                  rooms in
                  self.presenter?.presentRoomsSuccess(rooms: rooms)
              }.catch {
                  error in
                  self.presenter?.presentRoomsError(error: error.localizedDescription)
              }
    }
    
  
 
}




