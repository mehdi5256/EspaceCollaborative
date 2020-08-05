//
//  AccueilInteractor.swift
//  Espace_Collaboratif
//
//  Created by mehdi on 8/4/20.
//  Copyright (c) 2020 mehdi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AccueilBusinessLogic
{
  func doSomething(request: Accueil.Something.Request)
}

protocol AccueilDataStore
{
  //var name: String { get set }
}

class AccueilInteractor: AccueilBusinessLogic, AccueilDataStore
{
  var presenter: AccueilPresentationLogic?
  var worker: AccueilWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Accueil.Something.Request)
  {
    worker = AccueilWorker()
    worker?.doSomeWork()
    
    let response = Accueil.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
