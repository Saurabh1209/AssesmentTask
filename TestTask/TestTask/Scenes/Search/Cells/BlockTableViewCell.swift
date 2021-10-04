//
//  BlockTableViewCell.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 01/10/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import UIKit


class BlockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblBlockName:UILabel!
    @IBOutlet weak var lblStepName:UILabel!
    @IBOutlet weak var lblApartment:UILabel!
    @IBOutlet weak var lblActivityName:UILabel!
    @IBOutlet weak var lblPercent:UILabel!
    @IBOutlet weak var bgview:UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    var activityData: Activity! {
          didSet {
              self.lblStepName.text = activityData?.stepName ?? ""
              self.lblActivityName.text = activityData?.activityName ?? ""
            self.lblPercent.text = "\(activityData.progress ?? 0 )%"
            self.progressView.progress = Float(activityData.progress ?? 0)/100
            
            switch (activityData.progress) {
            case let x where x ?? 0 < 30:
                  self.progressView.tintColor = UIColor.red
                self.lblApartment.textColor = UIColor.red
              case let x where x == 60:
                  self.progressView.tintColor = UIColor.systemYellow
                self.lblApartment.textColor = UIColor.systemBlue
            case let x where x ?? 0 > 0:
                  self.progressView.tintColor = UIColor.systemGreen
                self.lblApartment.textColor = UIColor.systemBlue
              default:
                self.lblApartment.textColor = UIColor.red
                  self.progressView.tintColor = UIColor.red
              }
          }
      }
    
    var unitData: Unit! {
        didSet {
            self.lblApartment.text = "\(unitData.apt ?? "")D."
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
