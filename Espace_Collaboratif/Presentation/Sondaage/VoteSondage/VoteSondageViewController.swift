//
//  VoteSondageViewController.swift
//  Espace_Collaboratif
//
//  Created by mehdi on 7/8/20.
//  Copyright (c) 2020 mehdi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Alamofire

protocol VoteSondageDisplayLogic: class
{
  func displaySomething(viewModel: VoteSondage.Something.ViewModel)
}

class VoteSondageViewController: UIViewController, VoteSondageDisplayLogic
{
  var interactor: VoteSondageBusinessLogic?
  var router: (NSObjectProtocol & VoteSondageRoutingLogic & VoteSondageDataPassing)?

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
  
    @IBOutlet weak var tv: UITableView!
    @IBAction func btnvalid(_ sender: Any) {
    }
    @IBOutlet weak var suestlbl: UILabel!
    @IBOutlet weak var viewquestion: UIView!
    // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = VoteSondageInteractor()
    let presenter = VoteSondagePresenter()
    let router = VoteSondageRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
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
    
    var sondageArray:[Choix] = []
    var question : String?
    var selectedIndexPath: IndexPath? = nil
    var selectedIndexes = [[IndexPath.init(row: 0, section: 0)], [IndexPath.init(row: 0, section: 1)]]
    
    var idvote: Int?
    
    var instanceOfVCA:MessengerViewController!

    override func viewDidAppear(_ animated: Bool) {
//         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchRendezVous"), object: nil)
    }
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
     tv.register(UINib(nibName: "VoteTableViewCell", bundle: nil), forCellReuseIdentifier: "VoteTableViewCell")
   
    suestlbl.text = question
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = VoteSondage.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: VoteSondage.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    @IBAction func SendVote(_ sender: Any) {
        
        let myUrl = Keys.MobileIntegrationServer.baseURL+"/vote/\(idvote!)"
        print(myUrl)
              
                     let parameters: [String: Any] = [
                             
                    "id": UserDefaultLogged.idUD,
        ]

                     AF.request(myUrl, method: .post, parameters: parameters,encoding: JSONEncoding.init())
                         .responseJSON { response in
                             print(response.result)
                       //     self.instanceOfVCA.tv.reloadData()

                            self.dismiss(animated: true, completion: nil)


                     }
    }
    
}


extension VoteSondageViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sondageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellchoix = tv.dequeueReusableCell(withIdentifier: "VoteTableViewCell", for: indexPath) as! VoteTableViewCell
        cellchoix.choixlbl.text = sondageArray[indexPath.row].body
        
        return cellchoix
        
    }
//
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(sondageArray[indexPath.row].id)
//
//        if selectedIndexPath == indexPath {
//            // it was already selected
//            selectedIndexPath = nil
//            tableView.deselectRow(at: indexPath, animated: false)
//        } else {
//            // wasn't yet selected, so let's remember it
//            selectedIndexPath = indexPath
//        }
//        print (selectedIndexPath)
//    }
    
    
   func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if let cellbutton = (tableView.cellForRow(at: indexPath) as! VoteTableViewCell).checkedimg {
        
        cellbutton.setImage(UIImage(named: "UnChecked"), for: .normal)
        idvote = sondageArray[indexPath.row].id
        print(idvote)

            
    }
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let cellbutton = (tableView.cellForRow(at: indexPath) as! VoteTableViewCell).checkedimg {
            
            cellbutton.setImage(UIImage(named: "verified"), for: .normal)
        idvote = sondageArray[indexPath.row].id
        print(idvote)

                
        }
    }
}
