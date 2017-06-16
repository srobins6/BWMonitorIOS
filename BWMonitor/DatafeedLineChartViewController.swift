//
//  DatafeedLineChartViewController.swift
//  BWMonitor
//
//  Created by Sol Robinson on 6/16/17.
//  Copyright © 2017 NCSA. All rights reserved.
//

import UIKit
import Charts

class DateTimeFormatter: NSObject, IAxisValueFormatter{

     func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateTime = Date(timeIntervalSince1970: value)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: dateTime)
    }
    
}

class DatafeedLineChartViewController: UIViewController {
    var datafeed: Datafeed = Datafeed()

    @IBOutlet weak var datafeedLineChartViewLineChartView: LineChartView!
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
                if let returnData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [[Double]] {
                    DispatchQueue.main.async {
                        var entries = [[ChartDataEntry]]()
                        let length = returnData!.count
                        let fieldsLength = self.datafeed.fields!.count
                        for _ in self.datafeed.fields!{
                            entries.append([ChartDataEntry]())
                        }
                        for index in 0..<length{
                            let dataPoint = returnData?[index]
                            let xValue = dataPoint?[0]
                            for fieldIndex in 1..<fieldsLength{
                                let yValue = dataPoint?[fieldIndex]
                                entries[fieldIndex].append(ChartDataEntry(x: xValue!, y: yValue!))
                            }
                            
                        }
                        var dataSets = [ILineChartDataSet]()
                        for fieldIndex in 1..<fieldsLength{
                            let set = LineChartDataSet(values: entries[fieldIndex], label: self.datafeed.fields?[fieldIndex])
                            set.valueFont = UIFont.systemFont(ofSize: 0)
                            dataSets.append(set)
                        }
                        self.datafeedLineChartViewLineChartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        self.datafeedLineChartViewLineChartView.chartDescription?.position = CGPoint(x: 0, y: 0)
                        self.datafeedLineChartViewLineChartView.legend.horizontalAlignment = Legend.HorizontalAlignment.left
                        self.datafeedLineChartViewLineChartView.legend.verticalAlignment = Legend.VerticalAlignment.top
                        self.datafeedLineChartViewLineChartView.legend.enabled = true
                        self.datafeedLineChartViewLineChartView.xAxis.granularity = 1
                        if(self.datafeed.type == "timechart"){
                            self.datafeedLineChartViewLineChartView.xAxis.valueFormatter = DateTimeFormatter()
                        }
                        let data = LineChartData(dataSets: dataSets)
                        self.datafeedLineChartViewLineChartView.data = data
                        
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
