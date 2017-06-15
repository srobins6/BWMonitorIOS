//
//  DatafeedTableViewController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/15/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

class DatafeedTableViewController: UITableViewController {
    @IBOutlet weak var datafeedsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datafeedsTableView.register(DatafeedTableViewCell.self, forCellReuseIdentifier: "DatafeedTableViewCell")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    
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
        let cellIdentifier = "DatafeedTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DatafeedTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DatafeedTableViewCell.")
        }
        
        return cell
    }
    
    
}
