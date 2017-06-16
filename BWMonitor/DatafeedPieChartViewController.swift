//
//  DatafeedPieChartViewController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/16/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit
import Charts

class DatafeedPieChartViewController: UIViewController {
    var datafeed: Datafeed = Datafeed()

    @IBOutlet weak var datafeedPieChartViewPieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
