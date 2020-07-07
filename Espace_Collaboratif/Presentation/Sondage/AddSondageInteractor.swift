//
//  AddSondageInteractor.swift
//  Espace_Collaboratif
//
//  Created by mehdi on 7/7/20.
//  Copyright (c) 2020 mehdi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AddSondageBusinessLogic
{
  func doSomething(request: AddSondage.Something.Request)
}

protocol AddSondageDataStore
{
  //var name: String { get set }
}

class AddSondageInteractor: AddSondageBusinessLogic, AddSondageDataStore
{
  var presenter: AddSondagePresentationLogic?
  var worker: AddSondageWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: AddSondage.Something.Request)
  {
    worker = AddSondageWorker()
    worker?.doSomeWork()
    
    let response = AddSondage.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
