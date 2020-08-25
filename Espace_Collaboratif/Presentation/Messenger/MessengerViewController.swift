//
//  MessengerViewController.swift
//  Espace_Collaboratif
//
//  Created by mehdi on 4/30/20.
//  Copyright (c) 2020 mehdi. All rights reserved.
//
//  This file was generated by the Clean S@objc wift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import JitsiMeet
import Alamofire
import CoreData
import GTProgressBar
import GrowingTextView


class DataManager {
    
    static let shared = DataManager()
    var mvc = MessengerViewController()
}


protocol MessengerDisplayLogic: class
{
    func displayrRoomByIdSuccess(roomdid :[Messenger1])
    func displayrRoomByIdError(error: String)
    func displayPostMsgSucess(msg :[Messenger1])
    func displayPostMsgError(error: String)
    func displayConnexionSuccess(result: String)
    func displayError(error: String)
    func displayMessenger(messenger:Messenger1)
    
    func displaySendMessageEventBus(result:String)
    
    func displayPostImgSucess(img :[Messenger1])
    func displayPostImgError(error: String)
    
    func displayReaction(reaction: Reaction1,messageId:Int)
    
    func displayIdRoomEventBus(id: Room1)
    
    func DisplayVoteEventBus(idMessage: Int, idChoix: Int, user: User)
    
    
    
}

class MessengerViewController: UIViewController, MessengerDisplayLogic
{
    func DisplayVoteEventBus(idMessage: Int, idChoix: Int, user: User) {
        
        
        let index: Int? = msgarray.firstIndex {
            $0.id == idMessage
            
            
        }
        
        let indexchoix: Int? = msgarray[index!].choix?.firstIndex {
            $0.id == idChoix
            
            
        }
        
        
        
        var indexxuser = -1
        var indexChoixU = -1
        msgarray[index!].choix?.enumerated().forEach{ c in
            let indexUser: Int? = c.element.users.firstIndex {
                $0.id == user.id
            }
            if(indexUser != nil){
                indexxuser = indexUser!
                indexChoixU = c.offset
            }
        }
        if indexxuser != -1 {
            msgarray[index!].choix![indexChoixU].users.remove(at: indexxuser)
        }
        
        msgarray[index!].choix![indexchoix!].users.append(user)
        
        let indexPath = IndexPath(row: index! , section: 0)
        DispatchQueue.main.async {
            self.tv.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func displayIdRoomEventBus(id: Room1) {
        self.idroomEventBus = id.id
        
    }
    
    
    
    
    func displaySendMessageEventBus(result: String) {
        print(result)
    }
    
    func isEntityAttributeExist(id: Int32, entityName: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %u", id)
        
        let res = try! managedContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    func displayMessenger(messenger: Messenger1) {
        self.msgarray.append(messenger)

        self.tv.reloadData()
        if (msgarray.count > 0){
            tv.scrollToBottom(animated: false)

        }

    }
    
    
    func displayConnexionSuccess(result: String) {
        print(result)
        interactor?.registerMessenger(id: idroom)
    }
    
    func displayError(error: String) {
        print(error)
    }
    
    
    var interactor: MessengerBusinessLogic?
    var router: (NSObjectProtocol & MessengerRoutingLogic & MessengerDataPassing)?
    
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
        let interactor = MessengerInteractor()
        let presenter = MessengerPresenter()
        let router = MessengerRouter()
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
    
    
    //outlets
    @IBOutlet weak var emptytvimg: UIImageView!
    @IBOutlet weak var message: GrowingTextView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var BtnSideUp: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var btnlastrow: UIButton!
    @IBOutlet weak var RoomName: UILabel!
    @IBOutlet weak var ViewEntete: UIView!
    
    @IBOutlet weak var bottomtextview: NSLayoutConstraint!
    
    @IBOutlet weak var BtnBack: UIButton!
    
    @IBOutlet weak var BtnAudio: UIButton!
    @IBOutlet weak var BtnVideo: UIButton!
    //coredata
    
    // var msgscoredataarray = MessageCoreData.all
    
    
    
    var countUsers = 0
    
    var MessagesArrayCoreData: [MessageCoreData] = []
    
    
    
    let reachability = try! Reachability()
    
    
    // MARK: View lifecycle
    
    // debut jitsi
    
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    fileprivate var jitsiMeetView: JitsiMeetView?
    //fin jitsi
    
    //  open gallery
    var imagePicker = UIImagePickerController()
    
    //end
    
    var nomroom:String?
    var idroom:Int!
    var idroomEventBus:Int!
    
    var msgarray:[Messenger1] = []
    var reactionsArray:[Reaction1] = []
    var choixcell: [Choix] = []
    
    
    
    var RoomSelectecCoreData : RoomCoreData?
    
    
    override func viewWillAppear(_ animated: Bool) {
        tv.register(UINib(nibName: "TextSenderCell", bundle: nil), forCellReuseIdentifier: "TextSenderCell")
        tv.register(UINib(nibName: "TextReceiverCell", bundle: nil), forCellReuseIdentifier: "TextReceiverCell")
        
        tv.register(UINib(nibName: "ImageSenderCell", bundle: nil), forCellReuseIdentifier: "ImageSenderCell")
        
        tv.register(UINib(nibName: "ImageReceiverCell", bundle: nil), forCellReuseIdentifier: "ImageReceiverCell")
        
        tv.register(UINib(nibName: "TextReceiverCell1", bundle: nil), forCellReuseIdentifier: "TextReceiverCell1")
        
         tv.register(UINib(nibName: "TextSenderCell1", bundle: nil), forCellReuseIdentifier: "TextSenderCell1")
        

        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // tv.reloadData()
        

        
       
    }
    
    
    
    @IBAction func DismissKeyBoard(_ sender: UITapGestureRecognizer) {
        message.resignFirstResponder()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            self.interactor?.getRoomById(id: self.idroom)
            
            
            
        case .cellular:
            print("Reachable via Cellular")
        case .unavailable:
            print("Network not reachable")
            
            
        case .none:
            print("none")
            
        }
    }
    
    @objc func fetchData(){
        tv.reloadData()
        if (msgarray.count > 0){
            tv.scrollToBottom(animated: false)

        }
    }
    override func viewDidLoad()
    {
        
        self.interactor?.getRoomById(id: self.idroom)
        self.interactor?.GetRoomEventBusid(id: self.idroom)
        
        super.viewDidLoad()
        
        UserDefaultLogged.idRoom = self.idroom
        
        let request:NSFetchRequest<MessageCoreData> = MessageCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "room.name", ascending: false)
        ]
        
        switch NetworkStatus.Connection() {
               case false:
        request.predicate = NSPredicate(format: "room.name == %@", RoomSelectecCoreData!.name!)
        default:
            print("okok")
        }
        
        MessagesArrayCoreData =   try! AppDelegate.viewContext.fetch(request)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        
        
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.interactor?.getRoomById(id: self.idroom)
                
                
            } else {
                print("Reachable via Cellular")
                
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            
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
        
        
        
        btnlastrow.roundCorners([.topLeft, .bottomLeft] , radius: 8)
        
        ViewEntete.roundCorners([.topLeft, .topRight] , radius: 50)

        interactor?.connect()
        
        RoomName.text = self.nomroom
       
        
        
        design()
        
        
       // *** Customize GrowingTextView ***
        message.layer.cornerRadius = 15.0

        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
       
       
    }
    
    
    
     deinit {
          NotificationCenter.default.removeObserver(self)
      }
      
      @objc private func keyboardWillChangeFrame(_ notification: Notification) {
          if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
              var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
              if #available(iOS 11, *) {
                  if keyboardHeight > 0 {
                      keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                  }
              }
              bottomtextview.constant = keyboardHeight + 8
              view.layoutIfNeeded()
            if (msgarray.count > 0){
                tv.scrollToBottom(animated: false)

            }
          }
      }

      @objc func tapGestureHandler() {
          view.endEditing(true)
      }
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func LastRowAction(_ sender: Any) {
        tv.scrollToBottom(animated: true)
    }
    
    @IBAction func BtnSend(_ sender: Any) {
        
        switch NetworkStatus.Connection() {
        case false:
            print("not conncted")
            
            
            let alert = UIAlertController(title: "", message: "Impossible D'envoyer un message. Assurer-vous que votre téléphone est connecté à Internet et réessayez.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            
        default:
            
            let msgtxtview : String = self.message.text
            
            interactor?.send(idroom: self.idroom, messagesend: message.text, type:"TEXT", file: "")
            
            designbuttonaftersend()
            
            if (msgarray.count > 0){
                tv.scrollToBottom(animated: false)

            }        }
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    
    func displayrRoomByIdError(error: String) {
        print(error)
        
    }
    
    func displayrRoomByIdSuccess(roomdid: [Messenger1]) {
        
        self.msgarray = roomdid
        
        for mmm in  self.msgarray{
            
            
            if self.isEntityAttributeExist(id: Int32(mmm.id!), entityName: "MessageCoreData"){
                
            }
            else{
                let msgcc = MessageCoreData(context: AppDelegate.viewContext)
                msgcc.id = Int32(mmm.id!)
                msgcc.body = mmm.body
                msgcc.file = mmm.file
                msgcc.firstname = mmm.user.firstName
                msgcc.lastname = mmm.user.lastName
                msgcc.imguser = mmm.user.image
                //   msgcc.timestamp = mmm.timestamp
                msgcc.room =  RoomSelectecCoreData
                msgcc.type = mmm.type
                
                
                
                try? AppDelegate.viewContext.save()
                
                
                
            }
            
            
        }
        tv.reloadData()
        if (msgarray.count > 0){
            tv.scrollToBottom(animated: false)

        }
        
    }
    
    func displayPostMsgError(error: String) {
        print(error)
    }
    
    func displayPostMsgSucess(msg: [Messenger1]) {
        print(msg)
    }
    
    func displayPostImgSucess(img: [Messenger1]) {
        print(img)
        
    }
    
    func displayPostImgError(error: String) {
        print(error)
    }
    
  
    
}


//// extension jitsi configuration jitsi



extension MessengerViewController: JitsiMeetViewDelegate {
    
    
    @IBAction func OpenAudioCall(_ sender: Any) {
        
        
        switch reachability.connection {
        case .wifi:
            
         JitsicCall(Videouted:true)
         case .cellular:

            
            print("Reachable via Cellular")
        case .unavailable:
            print("Network not reachable")
            
            let alert = UIAlertController(title: "", message: "Impossible D'émettre un appel. Assurer-vous que votre téléphone est connecté à Internet et réessayez.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            
        case .none:
            print("none")
            
        }
      }
    
    @IBAction func OpenVideoCall(_ sender: Any) {
        
        switch reachability.connection {
               case .wifi:
                   
               JitsicCall(Videouted:false)

                case .cellular:

                   
                   print("Reachable via Cellular")
               case .unavailable:
                   print("Network not reachable")
                   
                   let alert = UIAlertController(title: "", message: "Impossible D'émettre un appel. Assurer-vous que votre téléphone est connecté à Internet et réessayez.", preferredStyle: UIAlertController.Style.alert)
                   
                   // add an action (button)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                   
                   // show the alert
                   self.present(alert, animated: true, completion: nil)
                   
                   
               case .none:
                   print("none")
                   
               }
        
       }
    
    func JitsicCall(Videouted:Bool){
        
        
        cleanUp()
            // create and configure jitsimeet view
            let jitsiMeetView = JitsiMeetView()
            jitsiMeetView.delegate = self
            self.jitsiMeetView = jitsiMeetView
            let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
                builder.welcomePageEnabled = true
                 builder.videoMuted = Videouted
                builder.audioOnly = Videouted
                builder.welcomePageEnabled = false
                builder.serverURL = (URL(string: Keys.MobileIntegrationServer.jitsiURL))
                builder.room = self.nomroom
                
            }
            jitsiMeetView.join(options)
        
        BtnAudio.isEnabled = false
            BtnBack.isEnabled = false
        BtnVideo.isEnabled = false


            // Enable jitsimeet view to be a view that can be displayed
            // on top of all the things, and let the coordinator to manage
            // the view state and interactions
            pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
            pipViewCoordinator?.configureAsStickyView(withParentView: view)
            
            // animate in
            jitsiMeetView.alpha = 0
            pipViewCoordinator?.show()
        
        
    }
        fileprivate func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
            
            BtnAudio.isEnabled = true
                      BtnBack.isEnabled = true
                  BtnVideo.isEnabled = true
        
    }
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.hide() { _ in
                self.cleanUp()
            }
        }
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.enterPictureInPicture()
        }
    }
    func reverse(_ str: String) -> String {
        return String(str.reversed())
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        pipViewCoordinator?.resetBounds(bounds: rect)
    }
    
}

extension MessengerViewController: ReactionDelegate {
    
    func displayReaction(reaction: Reaction1,messageId:Int) {
        
        let index: Int? = msgarray.firstIndex {
            $0.id == messageId
            
            
        }
        
        
        
            if (msgarray[index!].reactions?.contains(where: { $0.user.id == reaction.user.id }))! {
            // found
            print("found")
            
            let userIndex: Int? = msgarray[index!].reactions?.firstIndex {
                $0.user.id == reaction.user.id
                
            }
            msgarray[index!].reactions?.remove(at:userIndex ?? 0 )
            
        }
        
        msgarray[index!].reactions?.append(reaction)
        if (msgarray[index!].reactions == nil )
        {
            msgarray[index!].reactions = []
            
            
        }
        let indexPath = IndexPath(row: index! , section: 0)
        tv.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func ReactionPost(tag: Int) {
        
        let user = User(id: UserDefaultLogged.idUD, firstName: UserDefaultLogged.firstNameUD, lastName: UserDefaultLogged.lasttNameUD, email: UserDefaultLogged.emailUD, image: UserDefaultLogged.IMGUD, username: UserDefaultLogged.firstNameUD)
        
        let reaction = Reaction1(id: nil, type: TextReceiverCell.typereac!, user: user, message: msgarray[tag])
        
        interactor?.sendReaction(idroom: idroom, type: "REACTION", reaction: reaction)
        
        
    }
    
    func didButtonPressedreaction(tag: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ReactionsViewController") as! ReactionsViewController
        vc.modalPresentationStyle = .overFullScreen
        
        
        vc.reactionsArray = msgarray[tag].reactions ?? []
        self.present(vc,animated:true,completion: nil)
        
        
    }
    
    
}

extension MessengerViewController : UICollectionViewDelegate,UICollectionViewDataSource,SondageDelegate{
    func SondageVote(tag: Int) {
        
        UserDefaultLogged.idMsg = msgarray[tag].id!
        print("userdefault id message")
        print(UserDefaultLogged.idMsg)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "VoteSondageViewController") as! VoteSondageViewController
        vc.modalPresentationStyle = .overFullScreen
        

        
        vc.question = msgarray[tag].body
        vc.sondageArray = msgarray[tag].choix ?? []
        self.present(vc,animated:true,completion: nil)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countUsers = 0
        choixcell.forEach{c in
            self.countUsers += c.users.count
        }
        return choixcell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellx = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoixSondageCollectionViewCell", for: indexPath) as? ChoixSondageCollectionViewCell
            else{
                return ChoixSondageCollectionViewCell()
        }
        
        cellx.choixlbl.text =  self.choixcell[indexPath.item].body
        
        
        var stat = CGFloat(Double(choixcell[indexPath.row].users.count)/Double(self.countUsers))
        if(stat.isNaN){
            stat = 0
        }
        cellx.viewstatrep.progress = stat
        
        return cellx
        
    }
    
    
}


extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    
    
}


extension MessengerViewController: GrowingTextViewDelegate {
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    
   
}


extension UITableView {
    public func scrollToBottom(animated: Bool = true) {
        guard let dataSource = dataSource else {
            return
        }

        let sections = dataSource.numberOfSections?(in: self) ?? 1
        let rows = dataSource.tableView(self, numberOfRowsInSection: sections - 1)
        let bottomIndex = IndexPath(item: rows - 1, section: sections - 1)

        scrollToRow(at: bottomIndex,
                    at: .bottom,
                    animated: animated)
    }
    public func scrollToReversedBottom(animated: Bool = true) {
        guard let dataSource = dataSource else {
            return
        }

        let sections = dataSource.numberOfSections?(in: self) ?? 1
        let bottomIndex = IndexPath(item: 0, section: sections - 1)

        scrollToRow(at: bottomIndex,
                    at: .top,
                    animated: animated)
    }
}
