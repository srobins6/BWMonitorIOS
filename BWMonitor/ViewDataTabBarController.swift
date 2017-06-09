//
//  ViewDataTabBarController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/9/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

class ViewDataTabBarController: UITabBarController {

    func showDatafeeds(){
        self.performSegue(withIdentifier: "showDatafeeds", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let sourceURL = defaults.string(forKey: datafeedKeys.sourceURL)
        if(sourceURL == nil){
            self.showDatafeeds()
        }

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        let defaults = UserDefaults.standard
        let sourceURL = defaults.string(forKey: datafeedKeys.sourceURL)
        if(sourceURL == nil){
            let alertController = UIAlertController(title: "Error", message:
                "Invalid datafeed source URL", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default,handler: {alert in self.showDatafeeds()}))
            
            self.present(alertController, animated: true, completion: nil)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
