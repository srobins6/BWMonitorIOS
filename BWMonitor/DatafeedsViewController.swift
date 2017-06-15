//
//  DatafeedsTableViewController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/15/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

class DatafeedsViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var datafeedSourceUrlTextField: UITextField!
    
    var datafeeds = [String:[Datafeed]]()
    @IBOutlet weak var datafeedSourceUrlUpdateButton: UIButton!
    @IBAction func updateDatafeedSourceUrlButtonClick(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(datafeedSourceUrlTextField.text, forKey: datafeedKeys.sourceUrl)
        queryDatafeeds(datafeedSourceUrlTextField.text!)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        
        var sourceUrl = defaults.string(forKey: datafeedKeys.sourceUrl)
        if(sourceUrl != nil){
            datafeedSourceUrlTextField.text = sourceUrl
        }else{
            sourceUrl = datafeedSourceUrlTextField.text
        }
        self.queryDatafeeds(sourceUrl!)
        
    }
    func populateDatafeedsTable(_ data:Data){
        if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
            if let responseVersion = dictionary?["version"] as? Double {
                let defaults = UserDefaults.standard
                defaults.set(responseVersion, forKey: datafeedKeys.sourceUrlVersion)
                
            }
            if let responseDatafeeds = dictionary?["datafeeds"] as? [Any]{
                
                self.datafeeds = parseDatafeedsToDictionary(responseDatafeeds as! [[String : Any]])
                DispatchQueue.main.async {
                    (self.childViewControllers[0] as? DatafeedTableViewController)?.datafeedsTableView.reloadData()
                }
                
            }
            
        }
        
        
        
    }
    func queryDatafeeds(_ sourceUrl: String){
        var sourceUrl = sourceUrl
        if(sourceUrl.lowercased().range(of:"^https?:\\/\\/", options: .regularExpression) == nil){
            sourceUrl = "http://" + sourceUrl
        }
        
        let urlString = URL(string: sourceUrl)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    debugPrint(error!)
                    let alertController = UIAlertController(title: "Error", message:
                        "Invalid datafeed source Url", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default,handler: {alert in ()}))
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    if let usableData = data {
                        self.populateDatafeedsTable(usableData)
                    }
                }
            }
            task.resume()
        }
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
