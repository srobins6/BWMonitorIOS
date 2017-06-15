//
//  ViewDataTabBarController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/9/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

class ViewDataTabBarController: UITabBarController {
    
    var datafeeds = [Datafeed]()
    
    func showDatafeeds(){
        self.performSegue(withIdentifier: "showDatafeeds", sender: self)
    }
    func showViewData(_ data: Data){
        let defaults = UserDefaults.standard
        let datafeedSourceUrlVersion = defaults.double(forKey: datafeedKeys.sourceUrlVersion )
        if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
            if let responseVersion = dictionary?["version"] as? Double {
                if responseVersion != datafeedSourceUrlVersion{
                    let alertController = UIAlertController(title: "Alert", message:
                        "New Datafeeds Available", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default,handler: {alert in self.showDatafeeds()}))
                    
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
            }
            let subscribedDatafeeds = defaults.stringArray(forKey: datafeedKeys.subscribed)!
            if subscribedDatafeeds.count == 0{
                self.showDatafeeds()
            }
            if let responseDatafeeds = dictionary?["datafeeds"] as? [Any]{
                var datafeeds = [Datafeed]()
                var viewControllers = [UIViewController]()
                for responseDatafeed in responseDatafeeds as! [[String : Any]]{
                    let datafeed = Datafeed(responseDatafeed)
                    if(subscribedDatafeeds.contains(datafeed.url) && datafeed.type != "notification"){
                        datafeeds.append(datafeed)
                        let tabBarItem = UITabBarItem(title: datafeed.title, image: #imageLiteral(resourceName: "first"), tag: datafeeds.count)
                        if(datafeed.type == "text"){
                            let viewController = DatafeedTextViewController()
                            viewController.datafeed = datafeed
                            viewController.tabBarItem = tabBarItem
                            viewControllers.append(viewController)
                        }else if datafeed.type=="html"{
                            let viewController = DatafeedHTMLViewController()
                            viewController.datafeed = datafeed
                            viewController.tabBarItem = tabBarItem
                            viewControllers.append(viewController)
                        }

                    }
                }
                DispatchQueue.main.async {
                    self.viewControllers = viewControllers
                    self.datafeeds = datafeeds
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
                self.showDatafeeds()
            } else {
                if let usableData = data {
                    self.showViewData(usableData)
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let sourceUrl = defaults.string(forKey: datafeedKeys.sourceUrl)
        if(sourceUrl == nil){
            self.showDatafeeds()
        }else{
            self.queryDatafeeds(sourceUrl!)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        let sourceUrl = defaults.string(forKey: datafeedKeys.sourceUrl)
        if(sourceUrl == nil){
            let alertController = UIAlertController(title: "Error", message:
                "Invalid datafeed source Url", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default,handler: {alert in self.showDatafeeds()}))
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.queryDatafeeds(sourceUrl!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
