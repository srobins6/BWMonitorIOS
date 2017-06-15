//  AppDelegate.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/9/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit

struct datafeedKeys {
    static let sourceUrl = "datafeedSourceUrl"
    static let sourceUrlVersion = "datafeedSourceUrlVersion"
    static let subscribed = "subscribedDatafeeds"
}
let defaultSourceUrl = "bwmon.ncsa.illinois.edu/metriccharts/api/datafeeds"

class Datafeed{
    var title: String = ""
    var type: String = ""
    var category: String = ""
    var url: String = ""
    
    var fields: [String]?
    init(){
        
    }
    init(_ json:[String:Any]) {
        self.title = (json["title"] as? String)!
        self.type = (json["type"] as? String)!
        self.category = (json["category"] as? String)!
        self.url = (json["url"] as? String)!
        if let fields = json["fields"] as?  [String]{
            self.fields = fields
        }
        
    }
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        if defaults.stringArray(forKey: datafeedKeys.subscribed) == nil {
            defaults.set([String](), forKey:datafeedKeys.subscribed)
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

