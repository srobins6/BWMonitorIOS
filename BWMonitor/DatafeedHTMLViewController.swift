//
//  DatafeedHTMLViewController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/15/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

class DatafeedHTMLViewController: UIViewController {
    var datafeed: Datafeed = Datafeed()
    @IBOutlet weak var datafeedHTMLViewWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var datafeedUrl = self.datafeed.url
        if(datafeedUrl.lowercased().range(of:"^https?:\\/\\/", options: .regularExpression) == nil){
            datafeedUrl = "http://" + datafeedUrl
        }
        
        let urlString = URL(string: datafeedUrl)
        
        
        let urlRequest = URLRequest(url: urlString!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        self.datafeedHTMLViewWebView.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
