//
//  RoomViewController.swift
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
import CRRefresh
import Kingfisher
import CoreData

protocol RoomDisplayLogic: class
{
    func displayListeSuccess(rooms: [Room1])
    func displayListeError(error: String)
}

class RoomViewController: UIViewController, RoomDisplayLogic
{
  var interactor: RoomBusinessLogic?
  var router: (NSObjectProtocol & RoomRoutingLogic & RoomDataPassing)?
   
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
  
  private func setup()
  {
    let viewController = self
    let interactor = RoomInteractor()
    let presenter = RoomPresenter()
    let router = RoomRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//  {
//    if let scene = segue.identifier {
//      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
//      if let router = router, router.responds(to: selector) {
//        router.perform(selector, with: segue)
//      }
//    }
//  }
    
    // MARK: View lifecycle
    var rooms: [Room1] = []
    var usersCell: [User] = []
    var usersCoreDataArray: [User] = []

    let reachability = try! Reachability()

    //outlets
    @IBOutlet weak var ViewNoConnection: UIView!
    @IBOutlet weak var BtnAddOutlet: UIButton!
    @IBOutlet weak var tv: UITableView!
    
    // CORE DATA
    var roomsCD: [RoomCoreData] = []

    // END CORE DATA
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            interactor?.getRooms()
            ViewNoConnection.isHidden = true
        case .cellular:
            print("Reachable via Cellular")
        case .unavailable:
            ViewNoConnection.isHidden = false
            
            
        case .none:
            print("none")
            
        }
    }
   
    
    override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let request:NSFetchRequest<RoomCoreData> = RoomCoreData.fetchRequest()
    roomsCD =   try! AppDelegate.viewContext.fetch(request)
    
    setupButton()
    
    
    reachability.whenReachable = { reachability in
        if reachability.connection == .wifi {
            print("Reachable via WiFi")
            self.interactor?.getRooms()
            

        } else {
            print("Reachable via Cellular")

        }
    }
    reachability.whenUnreachable = { _ in
        print("Not reachable")
        self.ViewNoConnection.isHidden = true

    }

    do {
        try reachability.startNotifier()
    } catch {
        print("Unable to start notifier")
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do{
      try reachability.startNotifier()
    }catch{
      print("could not start reachability notifier")
    }
    
    
    //refresh table view
    
    
    let loadingFooter = NormalFooterAnimator()
           loadingFooter.loadingDescription = "Chargement "
           loadingFooter.noMoreDataDescription = "pas d'autres contacts"
           let loadingHeader = NormalHeaderAnimator()
           loadingHeader.loadingDescription = "Chargement "
           loadingHeader.pullToRefreshDescription = "Tirer pour rafraîchir"
           loadingHeader.releaseToRefreshDescription = "Relâcher pour rafraîchir"
           tv.backgroundColor = UIColor(named: "f5f5f5")
           
      /// animator: your customize animator, default is NormalHeaderAnimator
      tv.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
          /// start refresh
          /// Do anything you want...
          DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
              /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self?.interactor?.getRooms()
            self?.tv.cr.endHeaderRefresh()

          })
      }
      /// manual refresh
     // tv.cr.beginHeaderRefresh()
           
    
   
    // core data
   

    }
    
    func isEntityAttributeExist(id: Int32, entityName: String) -> Bool {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let managedContext = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
      fetchRequest.predicate = NSPredicate(format: "id == %u", id)

      let res = try! managedContext.fetch(fetchRequest)
      return res.count > 0 ? true : false
    }
    
    func setupButton() {
        
        BtnAddOutlet.layer.cornerRadius = 25
        BtnAddOutlet.layer.masksToBounds = true
        BtnAddOutlet.clipsToBounds = true
    }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
    
    func displayListeSuccess(rooms: [Room1]){
        self.rooms = rooms
        for r in  self.rooms{
            if self.isEntityAttributeExist(id: Int32(r.id!), entityName: "RoomCoreData"){
                print("duplication ma tzidech")
            }
            else{
                print("zid fel core data")
                let roomcc = RoomCoreData(context: AppDelegate.viewContext)
                roomcc.id = Int32(r.id!)
                roomcc.name = r.name
                roomcc.subject = r.subject
                let jsonData = try! JSONEncoder().encode(r.users)
               // let jsonString = String(data: jsonData, encoding: .utf8)!
              //  print(jsonString)
                roomcc.users = jsonData
                try? AppDelegate.viewContext.save()
                let request:NSFetchRequest<RoomCoreData> = RoomCoreData.fetchRequest()
                   roomsCD =   try! AppDelegate.viewContext.fetch(request)
                
                
            }
        }
        tv.reloadData()
        
    }
    
    func displayListeError(error: String) {
        print(error)
    }
    
    @IBAction func AddRoomAction(_ sender: Any) {
        
    }
}



extension RoomViewController: UITableViewDataSource{
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          switch NetworkStatus.Connection() {
          case false:
              print("not conncted")
              return self.roomsCD.count

          default:
              print("connected")
              return rooms.count
          }
          
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RoomsTableViewCell else {
        return tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                                 }
        
        switch NetworkStatus.Connection() {
        case false:
            print("not conncted")
            
            //         affichage core data
            cell.RoomName.text = roomsCD[indexPath.item].name!
            cell.UserName.text = roomsCD[indexPath.item].subject
            cell.NumPoste.text  =  (roomsCD[indexPath.item].id).description
            usersCoreDataArray = try! JSONDecoder().decode([User].self, from: roomsCD[indexPath.row].users! )

      
        default:
            
            let roomindex = rooms[indexPath.item]
            cell.RoomName.text = roomindex.name!
            cell.UserName.text = roomindex.subject!
            cell.NumPoste.text  =  (roomindex.id!).description
            self.usersCell = roomindex.users
        }
        
        cell.selectionStyle = .none
        let frequency = indexPath.item % 10;
        switch (frequency) {
        case 0:
            cell.setGradientBackground(colorOne: Colors.skyblue, colorTwo: Colors.skyblue2)
            break;
        case 1:
            cell.setGradientBackground(colorOne: Colors.purple, colorTwo: Colors.blue)
            break;
            
        case 2:
            cell.setGradientBackground(colorOne: Colors.purple1, colorTwo: Colors.purple2)
            break;
            
        case 3:
            cell.setGradientBackground(colorOne: Colors.orange1, colorTwo: Colors.orange2)
            break;
        case 4:
            cell.setGradientBackground(colorOne: Colors.lightGrey, colorTwo: Colors.veryDarkGrey)
            break;
        //up to case 9
        default:
            break;
        }
        
        return  cell
    }

}

extension RoomViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch NetworkStatus.Connection() {
               case false:
            return usersCoreDataArray.count>4 ?  4 : usersCoreDataArray.count;

                
                default:

        return usersCell.count>4 ?  4 : usersCell.count;
        }

        }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch NetworkStatus.Connection() {
                      case false:
                        
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as? UserCollectionViewCell
                                     else{
                                         return UserCollectionViewCell()
                                 }
                               
                          let image = self.usersCoreDataArray[indexPath.item].image
                          cell.lblnmbruser.text = "+" + (usersCoreDataArray.count-4).description


                         cell.UserImage.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "ic_user")) {
                             result in
                             switch result {
                             case .success:
                                 break
                             case .failure:
                                 cell.UserImage.image = UIImage(named: "ic_user")!
                             }
                         }
                          
                          
                          
                          if (indexPath.item) < 3 {
                              
                              cell.lblnmbruser.isHidden = true
                              
                              
                          }
                          if (indexPath.item) == 3 {
                              
                              cell.lblnmbruser.isHidden = false
                              
                              
                          }
                          return cell
                          
                      
                       default:
      

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as? UserCollectionViewCell
                   else{
                       return UserCollectionViewCell()
               }
             
        let image = self.usersCell[indexPath.item].image
        cell.lblnmbruser.text = "+" + (usersCell.count-4).description


       cell.UserImage.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "ic_user")) {
           result in
           switch result {
           case .success:
               break
           case .failure:
               cell.UserImage.image = UIImage(named: "ic_user")!
           }
       }
        
        
        
        if (indexPath.item) < 3 {
            
            cell.lblnmbruser.isHidden = true
            
            
        }
        if (indexPath.item) == 3 {
            
            cell.lblnmbruser.isHidden = false
            
            
        }
        return cell
        
    }
          }
    
    
}

extension RoomViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -130
    }
    
    
   
    
    
}

extension RoomViewController:UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "todetail", sender: indexPath)
           
       }
    
    
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch reachability.connection {
        case .wifi:
            if segue.identifier == "todetail"{
                let DVC = segue.destination as! MessengerViewController
                let indice = sender as! IndexPath
                
                DVC.nomroom = rooms[indice.row].name
                DVC.idroom = rooms[indice.row].id
                
                //CORE DATA
                
                DVC.RoomSelectecCoreData = roomsCD[indice.row]
                
                DVC.nomroom = roomsCD[indice.row].name
                DVC.RoomSelectecCoreData = roomsCD[indice.row]
                navigationItem.backBarButtonItem = UIBarButtonItem(title: DVC.nomroom , style: .plain, target: nil, action: nil)
               
            }
            
            
        case .cellular:
            print("Reachable via Cellular")
        case .unavailable:
            if segue.identifier == "todetail"{
                
                let DVC = segue.destination as! MessengerViewController
                let indice = sender as! IndexPath
                DVC.nomroom = roomsCD[indice.row].name
                DVC.RoomSelectecCoreData = roomsCD[indice.row]
                
                navigationItem.backBarButtonItem = UIBarButtonItem(title: DVC.nomroom , style: .plain, target: nil, action: nil)
                
                
            }
            
        case .none:
            print("none")
            
        }
        
        
    }
    
    
}
