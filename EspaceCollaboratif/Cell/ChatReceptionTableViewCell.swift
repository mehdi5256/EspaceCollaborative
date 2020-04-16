//
//  ChatReceptionTableViewCell.swift
//  EspaceCollaboratif
//
//  Created by mehdi on 4/10/20.
//  Copyright © 2020 mehdi drira. All rights reserved.
//

import UIKit

class ChatReceptionTableViewCell: UITableViewCell {
    @IBOutlet weak var usernamelbl: UILabel!
    @IBOutlet weak var viewtop: UIView!
       @IBOutlet weak var ViewbOTTOMTIMESTAMP: UIView!
       @IBOutlet weak var viewleft: UIView!
       @IBOutlet weak var timestamp: UILabel!
       @IBOutlet weak var viewright: UIView!
           @IBOutlet weak var msgtxt: UITextView!
           @IBOutlet weak var message: UIStackView!
           @IBOutlet weak var imguser: UIImageView!
           @IBOutlet weak var viewimg: UIView!
           override func awakeFromNib() {
               super.awakeFromNib()
               // Initialization code
           }

           override func setSelected(_ selected: Bool, animated: Bool) {
               super.setSelected(selected, animated: animated)

     // ViewbOTTOMTIMESTAMP.layer.cornerRadius = 10
                       
                       
                       viewimg.layer.masksToBounds = false
                              viewimg.layer.cornerRadius = viewimg.frame.height/2
                              viewimg.clipsToBounds = true
                       
                       
                       imguser.layer.masksToBounds = false
                       imguser.layer.cornerRadius = imguser.frame.height/2

                       imguser.clipsToBounds = true
                       
                       
             viewleft.roundCorners([.topLeft, .topLeft] , radius: 10)
               //  viewright.roundCorners([.topRight, .topRight] , radius: 10)

               viewtop.roundCorners([.topLeft, .topRight] , radius: 10)
               ViewbOTTOMTIMESTAMP.roundCorners([.bottomLeft, .bottomRight] , radius: 10)
            // ViewbOTTOMTIMESTAMP.roundCorners([.topLeft, .topRight] , radius: 10)




                   }
                   
                   

               }

       
