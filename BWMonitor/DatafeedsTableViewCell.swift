//
//  DatafeedTableViewCell.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/13/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

class DatafeedsTableViewCell: UITableViewCell {
    @IBOutlet weak var datafeedSubscribedSwitch: UISwitch!

    @IBOutlet weak var datafeedTitleLabel: UILabel!
    var datafeed: Datafeed = Datafeed()
    @IBAction func datafeedSubscribedSwitchChange(_ sender: Any) {
        let defaults = UserDefaults.standard
        var subscribedDatafeeds = defaults.stringArray(forKey: datafeedKeys.subscribed)!
        if(self.datafeedSubscribedSwitch.isOn && !subscribedDatafeeds.contains(datafeed.url)){
            subscribedDatafeeds.append(datafeed.url)
            if(self.datafeed.type == "notification"){
                Messaging.messaging().subscribe(toTopic: self.datafeed.getTopic())
            }
        }else if (!self.datafeedSubscribedSwitch.isOn && subscribedDatafeeds.contains(datafeed.url)){
            subscribedDatafeeds.remove(at: subscribedDatafeeds.index(of: datafeed.url)!)
            if(self.datafeed.type == "notification"){
                Messaging.messaging().unsubscribe(fromTopic: self.datafeed.getTopic())
            }

        }
        defaults.set(subscribedDatafeeds, forKey: datafeedKeys.subscribed)

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
