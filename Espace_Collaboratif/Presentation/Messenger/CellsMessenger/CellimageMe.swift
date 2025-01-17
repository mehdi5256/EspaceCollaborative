//
//  CellimageMeTableViewCell.swift
//  EspaceCollaboratif
//
//  Created by mehdi on 4/16/20.
//  Copyright © 2020 mehdi drira. All rights reserved.
//

import UIKit

class CellimageMe: UITableViewCell {
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var viewsendimg: UIView!
    
     @IBOutlet weak var imagechat: UIImageView!
       @IBOutlet weak var viewleft: UIView!
            @IBOutlet weak var viewright: UIView!
         
            @IBOutlet weak var message: UIStackView!
            @IBOutlet weak var imguser: UIImageView!
        @IBOutlet weak var usernamelbl: UILabel!
        @IBOutlet weak var viewimg: UIView!
            override func awakeFromNib() {
                super.awakeFromNib()
                // Initialization code
            }

            override func setSelected(_ selected: Bool, animated: Bool) {
                super.setSelected(selected, animated: animated)

           imagechat.layer.cornerRadius = 10
                    viewsendimg.layer.cornerRadius = 10
                    
                        
                        viewimg.layer.masksToBounds = false
                               viewimg.layer.cornerRadius = viewimg.frame.height/2
                               viewimg.clipsToBounds = true
                        
                        
                        imguser.layer.masksToBounds = false
                        imguser.layer.cornerRadius = imguser.frame.height/2

                        imguser.clipsToBounds = true
                        
                        

                    viewleft.roundCorners([.topLeft, .topLeft] , radius: 10)
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
