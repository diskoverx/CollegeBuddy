
// Name : Nithin Raju Chandy
// EventTableViewCell.swift
// Last updated : Nov 19, 2015

//***************************************************************
//  IMPLEMENTS TABLEVIEW CELLS
//****************************************************************

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var event_Title: UILabel!
    @IBOutlet weak var event_Description: UILabel!
    @IBOutlet weak var added_By: UILabel!
    @IBOutlet weak var added_Date: UILabel!
    @IBOutlet weak var event_Image: UIImageView!
    
    @IBAction func op_back(sender: AnyObject) {
        
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
