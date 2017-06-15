//
//  DatafeedsTableViewController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/15/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

class DatafeedsViewController: UIViewController {
    
    
    
    var datafeeds = [String:[Datafeed]]()
    
    @IBOutlet weak var datafeedSourceUrlTextField: UITextField!
    
    @IBOutlet weak var datafeedSourceUrlUpdateButton: UIButton!
    @IBAction func updateDatafeedSourceUrlButtonClick(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(datafeedSourceUrlTextField.text, forKey: datafeedKeys.sourceUrl)
        queryDatafeeds(datafeedSourceUrlTextField.text!)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        
        var sourceUrl = defaults.string(forKey: datafeedKeys.sourceUrl)
        if(sourceUrl != nil){
            datafeedSourceUrlTextField.text = sourceUrl
        }else{
            datafeedSourceUrlTextField.text = defaultSourceUrl
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
                
                var datafeeds = [String:[Datafeed]]()
                for responseDatafeed in responseDatafeeds as! [[String : Any]]{
                    let datafeed = Datafeed(responseDatafeed )
                    if datafeeds[datafeed.category] == nil{
                        datafeeds[datafeed.category] = [Datafeed]()
                    }
                    datafeeds[datafeed.category]?.append(datafeed)
                }
                self.datafeeds = datafeeds
                DispatchQueue.main.async {
                    (self.childViewControllers[0] as? DatafeedsTableViewController)?.datafeedsTableView.reloadData()
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
        
        
        let urlRequest = URLRequest(url: urlString!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
