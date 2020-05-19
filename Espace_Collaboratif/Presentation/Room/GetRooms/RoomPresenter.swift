//
//  RoomPresenter.swift
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

protocol RoomPresentationLogic
{
    func presentRoomsSuccess(rooms: [Room1])
    func presentRoomsError(error: String)
}

class RoomPresenter: RoomPresentationLogic
{
    weak var viewController: RoomDisplayLogic?
    
    // MARK: Do something
   
    func presentRoomsSuccess(rooms: [Room1]){
        viewController?.displayListeSuccess(rooms: rooms)
    }
    
    func presentRoomsError(error: String){
        viewController?.displayListeError(error: error)
    }
    
    
  
  }



