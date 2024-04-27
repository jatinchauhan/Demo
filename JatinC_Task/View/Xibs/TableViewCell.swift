//
//  TableViewCell.swift
//  JatinC_Task
//
//  Created by Jatin Chauhan on 27/04/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgArrow: UIImageView!
    
    var dataModel: DataModel? {
        didSet {
            if self.dataModel != nil {
                self.lblTitle.text = self.dataModel?.title ?? ""
                
                if self.dataModel?.detailAPICalled ?? false {
                    self.imgArrow.isHidden = false
                }
                else {
                    self.imgArrow.isHidden = true
                }
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
