//
//  CustomListViewCell.swift
//  OnTheMap
//
//  Created by Mac on 4/10/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

class CustomListViewCell: UITableViewCell {

    
    @IBOutlet weak var Stud_Name: UILabel!
    
    @IBOutlet weak var Stud_Loc: UILabel!
    
    @IBOutlet weak var InfoButton: UIImageView!
    
    @IBOutlet weak var EditButton: UIButton!

    @IBOutlet weak var DeleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
