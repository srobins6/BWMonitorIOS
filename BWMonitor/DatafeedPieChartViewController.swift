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
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                debugPrint(error!)
            } else {
                if let returnData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [Double] {
                    DispatchQueue.main.async {
                        var entries = [PieChartDataEntry]()
                        let length = returnData!.count
                        for index in 0..<length{
                            entries.append(PieChartDataEntry(value: returnData![index], label: self.datafeed.fields?[index]))
                        }
                        let set = PieChartDataSet(values: entries, label: self.datafeed.title)
                        set.valueTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        set.entryLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        set.entryLabelFont=UIFont.systemFont(ofSize: 12)
                        set.setColors(ChartColorTemplates.vordiplom(), alpha: 1.0)
                        let data = PieChartData(dataSet: set)
                        self.datafeedPieChartViewPieChartView.isMultipleTouchEnabled = false
                        self.datafeedPieChartViewPieChartView.drawHoleEnabled = false
                        self.datafeedPieChartViewPieChartView.data = data
                        self.datafeedPieChartViewPieChartView.legend.enabled = false
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
