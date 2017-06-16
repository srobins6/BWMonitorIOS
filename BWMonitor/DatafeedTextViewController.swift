//
//  DatafeedTextViewController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/15/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

class DatafeedTextViewController: UIViewController {
    
    var datafeed: Datafeed = Datafeed()
    @IBOutlet weak var datafeedTextViewTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print(1)
        super.viewDidAppear(animated)
        var datafeedUrl = self.datafeed.url
        if(datafeedUrl.lowercased().range(of:"^https?:\\/\\/", options: .regularExpression) == nil){
            datafeedUrl = "http://" + datafeedUrl
        }
        
        let urlString = URL(string: datafeedUrl)
        
        
        let urlRequest = URLRequest(url: urlString!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                debugPrint(error!)
            } else {
                if let returnData = String(data: data!, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.datafeedTextViewTextView.text = returnData
                    }
                }
            }
        }
        task.resume()
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
