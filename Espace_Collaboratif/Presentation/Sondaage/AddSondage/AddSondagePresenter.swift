//
//  AddSondagePresenter.swift
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

protocol AddSondagePresentationLogic
{
  func presentSomething(response: AddSondage.Something.Response)
  func sendSondageEventBus(result: String)
func presentConnexionSuccess(result: String)

    
}

class AddSondagePresenter: AddSondagePresentationLogic
{
  weak var viewController: AddSondageDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: AddSondage.Something.Response)
  {
    let viewModel = AddSondage.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
    
    func sendSondageEventBus(result: String) {
        viewController?.displaySendSondageEventBus(result: result)
    }
    
    func presentConnexionSuccess(result: String) {
        viewController?.displayConnexionSuccess(result:result)
    }
}
