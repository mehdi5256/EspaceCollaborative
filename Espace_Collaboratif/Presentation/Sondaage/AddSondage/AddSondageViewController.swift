//
//  AddSondageViewController.swift
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
import Alamofire

protocol AddSondageDisplayLogic: class
{
  func displaySomething(viewModel: AddSondage.Something.ViewModel)
    func displaySendSondageEventBus(result:String)
    func displayConnexionSuccess ( result:String)

}

class AddSondageViewController: UIViewController, AddSondageDisplayLogic
{
    func displaySendSondageEventBus(result: String) {
        print(result)
    }
    func displayConnexionSuccess(result: String) {
        print(result)
       // interactor?.connect()
    }
    
  var interactor: AddSondageBusinessLogic?
  var router: (NSObjectProtocol & AddSondageRoutingLogic & AddSondageDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
    var choix = [String]()
    

  
    @IBOutlet weak var ViewSondage: UIView!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var QuestionOutlet: UITextField!
    
    
    private func setup()
  {
    let viewController = self
    let interactor = AddSondageInteractor()
    
    let presenter = AddSondagePresenter()
    let router = AddSondageRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
    

    @IBAction func BtnChoice(_ sender: Any) {
      }
    
    
    
    @IBAction func BtnCreatePoll(_ sender: Any) {
        
        
        let choixSondageArray = self.choix.map({ ["body": $0] })
        print (choixSondageArray)
        var choixa :[Choi2] = []
        
        
        for x in choixSondageArray{
            
            let choix = Choi2( body: x["body"])
            choixa.append(choix)
        }
        
        print(choixa)
        
        
        
        let Sondage = Messenger2(body: QuestionOutlet.text, type: "SONDAGE", user: User(id: UserDefaultLogged.idUD, firstName: UserDefaultLogged.firstNameUD, lastName: UserDefaultLogged.lasttNameUD, email: UserDefaultLogged.emailUD, image: UserDefaultLogged.IMGUD, username: UserDefaultLogged.firstNameUD), choix: choixa,room: Room1(id: UserDefaultLogged.idRoom, users: []))
        
    interactor?.sendSondage(idroom: UserDefaultLogged.idRoom ,messagesend:Sondage, type: "SONDAGE")
        
        dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func AddChoiceAction(_ sender: Any) {
        let alert = UIAlertController(title: "Ajouter un choix", message: nil, preferredStyle: .alert)
                alert.addTextField{
                    (choixtf) in
                    choixtf.placeholder = "Ajouter un choix"
                }
                let action = UIAlertAction(title: "Ajouter un choix", style: .default){
                    (_) in
                    guard let choice = alert.textFields?.first?.text
                        else { return }
                   // print (choice)
                    self.choix.append(choice)
                  //  print(self.choix)
                    
                 
                   

                    self.tv.reloadData()
                    
                    
        //            self.addintable(choice)
                    }
                alert.addAction(action)
                present(alert,animated: true)
    }
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
    tv.isEditing = true
    interactor?.connect()


    ViewSondage.roundCorners([.topLeft, .topRight] , radius: 50)

    
    }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = AddSondage.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: AddSondage.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}


extension AddSondageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choix.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let choixcell = choix[indexPath.row]
        cell.textLabel?.text = choixcell
        cell.accessoryType = .disclosureIndicator
       // cell.editingAccessoryType = .checkmark
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        choix.remove(at: indexPath.row)
        tv.deleteRows(at: [indexPath], with: .left)
        print(self.choix)

    }
    
    
}
