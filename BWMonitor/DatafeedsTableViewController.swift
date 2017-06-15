//
//  DatafeedTableViewController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/15/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

class DatafeedsTableViewController: UITableViewController {
    @IBOutlet weak var datafeedsTableView: UITableView!
    
    var subscribedDatafeeds:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        self.subscribedDatafeeds = defaults.stringArray(forKey: datafeedKeys.subscribed)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(((self.parent as? DatafeedsViewController)?.datafeeds.keys.count)! > 0 ){
            return (self.parent as? DatafeedsViewController)?.datafeeds.keys.sorted()[section]
        }
        return ""
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ((self.parent as? DatafeedsViewController)?.datafeeds.keys.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(((self.parent as? DatafeedsViewController)?.datafeeds.keys.count)! > 0 ){
            return ((self.parent as? DatafeedsViewController)?.datafeeds[((self.parent as? DatafeedsViewController)?.datafeeds.keys.sorted()[section])!]!.count)!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DatafeedsTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!DatafeedsTableViewCell
        let datafeed = ((self.parent as? DatafeedsViewController)?.datafeeds[((self.parent as? DatafeedsViewController)?.datafeeds.keys.sorted()[indexPath.section])!]![indexPath.row])
        cell.datafeed = datafeed!
        cell.datafeedTitleLabel.text = datafeed?.title
        if (self.subscribedDatafeeds.contains((datafeed?.url)!)){
            cell.datafeedSubscribedSwitch.isOn = true
        }else{
            cell.datafeedSubscribedSwitch.isOn = false
        }
        return cell
    }
    
    
}
