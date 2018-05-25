//
//  UserStatisticsViewController.swift
//  ConPro
//
//  Created by Anton Danilov on 26.05.2018.
//  Copyright © 2018 ConPro. All rights reserved.
//

import UIKit
import Charts


class UserStatisticsViewController: UIViewController {
    
    @IBOutlet weak var favoriteCategoriesChart: HorizontalBarChartView!
    @IBOutlet weak var eventsVisitedLabel: UILabel!
    

    var currentUser: User?
    var categories = [String:Int]()
    
    
    //    @IBAction func segChanged(_ sender: UISegmentedControl) {
    //        switch sender.selectedSegmentIndex {
    //        case 0:
    //            updateChartData()
    //            self.userView.alpha = 1
    //            self.managerView.alpha = 0
    //            break
    //        case 1:
    //            self.userView.alpha = 0
    //            self.managerView.alpha = 1
    //            break
    //        default:
    //            self.userView.alpha = 1
    //        }
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCategoriesChart.chartDescription?.text = ""
        //        eventsVisitedLavel.text = "Events Visited:\(currentUser?.eventsVisited.count ?? 0)"
        eventsVisitedLabel.text = "Events Visited: 100"
        //        popCategories()
        categories["IT"] = 5
        categories["Sport"] = 3
        categories["Music"] = 7
        categories["Design"] = 1
        
        
        updateChartData()
        
        
    }
    func updateChartData() {
        var dataEntries = [ChartDataEntry]()
        
        for i in 0..<[Int](categories.values).count {
            let entry = BarChartDataEntry(x: Double(i), y: Double([Int](categories.values)[i]))
            
            dataEntries.append(entry)
        }
        let barChartDataSet = BarChartDataSet(values: dataEntries, label: "")
        barChartDataSet.drawValuesEnabled = false
        if #available(iOS 11.0, *) {
            barChartDataSet.colors = [UIColor(named: "Color-1"), UIColor(named: "Color-2"),UIColor(named: "Color-3"),UIColor(named: "Color-4")] as! [NSUIColor]
        } else {
            barChartDataSet.colors = ChartColorTemplates.joyful()
        }
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setDrawValues(true)
        favoriteCategoriesChart.data = barChartData
        favoriteCategoriesChart.legend.enabled = false
        
        favoriteCategoriesChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: [String](categories.keys) )
        favoriteCategoriesChart.xAxis.granularityEnabled = true
        favoriteCategoriesChart.xAxis.granularity = 1
        
        favoriteCategoriesChart.xAxis.gridColor = NSUIColor.groupTableViewBackground
        favoriteCategoriesChart.xAxis.axisLineColor = NSUIColor.groupTableViewBackground
        favoriteCategoriesChart.rightAxis.labelTextColor = NSUIColor.groupTableViewBackground
        favoriteCategoriesChart.leftAxis.labelTextColor = NSUIColor.groupTableViewBackground
        
        favoriteCategoriesChart.xAxis.labelPosition = .bottomInside
        favoriteCategoriesChart.xAxis.drawGridLinesEnabled = false
        
        
        favoriteCategoriesChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        
        favoriteCategoriesChart.data = barChartData
    }
    func popCategories()
    {
        var i = 0
        //        categories.removeAll()
        let eventsVisited = currentUser?.eventsVisited
        for event in eventsVisited!
        {
            for categoryKey in [String](categories.keys)
            {
                if categoryKey == event.eventCategory{
                    categories[categoryKey] = categories[categoryKey]! + 1
                    i+=1
                }
            }
            if i==0
            {
                categories[event.eventCategory!] = 1
            }
        }
    }
}
