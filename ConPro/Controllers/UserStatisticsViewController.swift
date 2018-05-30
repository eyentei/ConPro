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
    var categories : [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCategoriesChart.chartDescription?.text = ""
        eventsVisitedLabel.text = "Events Visited:\(currentUser?.eventsVisited.count ?? 100)"
        //        popCategories()
        categories["IT"] = 0
        categories["Sport"] = 2
        categories["Music"] = 2
        categories["Design"] = 5
        
        
        updateChartData()
        
        
    }
    func updateChartData() {
        var dataEntries = [ChartDataEntry]()
        
        for i in 0..<[Int](categories.values).count {
            let entry = BarChartDataEntry(x: Double(i), y: Double([Int](categories.values)[i]))
            dataEntries.append(entry)
        }
        let barChartDataSet = BarChartDataSet(values: dataEntries, label: nil)
        barChartDataSet.valueColors = [NSUIColor.groupTableViewBackground]
        barChartDataSet.drawValuesEnabled = true
        if #available(iOS 11.0, *) {
            barChartDataSet.colors = [UIColor(named: "Color-1"), UIColor(named: "Color-2"),UIColor(named: "Color-3"),UIColor(named: "Color-4")] as! [NSUIColor]
        } else {
            barChartDataSet.colors = ChartColorTemplates.joyful()
        }
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setValueTextColor(NSUIColor.groupTableViewBackground)
        barChartData.setValueFont(UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold))
        
        
        favoriteCategoriesChart.chartDescription?.text = ""
        favoriteCategoriesChart.legend.enabled = false
        
        favoriteCategoriesChart.xAxis.drawGridLinesEnabled = false
        favoriteCategoriesChart.xAxis.axisLineColor = NSUIColor.groupTableViewBackground
        favoriteCategoriesChart.rightAxis.labelTextColor = NSUIColor.groupTableViewBackground
        favoriteCategoriesChart.leftAxis.labelTextColor = NSUIColor.groupTableViewBackground
        favoriteCategoriesChart.leftAxis.axisMinimum = 0
        favoriteCategoriesChart.rightAxis.axisMinimum = 0
        favoriteCategoriesChart.leftAxis.drawGridLinesEnabled = false
        favoriteCategoriesChart.rightAxis.drawGridLinesEnabled = false
        favoriteCategoriesChart.leftAxis.drawAxisLineEnabled = false
        favoriteCategoriesChart.rightAxis.drawAxisLineEnabled = false
        favoriteCategoriesChart.leftAxis.drawTopYLabelEntryEnabled = true
        favoriteCategoriesChart.rightAxis.drawTopYLabelEntryEnabled = true
        favoriteCategoriesChart.leftAxis.drawBottomYLabelEntryEnabled = true
        favoriteCategoriesChart.rightAxis.drawBottomYLabelEntryEnabled = true
        favoriteCategoriesChart.rightAxis.drawLabelsEnabled = false
        favoriteCategoriesChart.leftAxis.drawLabelsEnabled = false
        
        favoriteCategoriesChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: [String](categories.keys))
        
        
        
        favoriteCategoriesChart.xAxis.labelPosition = .bottom
        favoriteCategoriesChart.xAxis.labelTextColor = NSUIColor.groupTableViewBackground
        favoriteCategoriesChart.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold)
        //        ageView.xAxis.labelFont = NSUIFont.init(name: "Futura", size: 15.0)!
        favoriteCategoriesChart.xAxis.drawGridLinesEnabled = false
        favoriteCategoriesChart.xAxis.granularity = 1
        
        
        
        
        favoriteCategoriesChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        
        barChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        favoriteCategoriesChart.drawValueAboveBarEnabled = true
        favoriteCategoriesChart.data = barChartData
    }
    //    func popCategories()
    //    {
    //        var i = 0
    //
    //        let eventsVisited = currentUser?.eventsVisited
    //
    //        for event in eventsVisited!
    //        {
    //            for categoryKey in [String](categories.keys)
    //            {
    //                if categoryKey == event.eventCategory{
    //                    categories[categoryKey] = categories[categoryKey]! + 1
    //                    i+=1
    //                }
    //            }
    //            if i==0
    //            {
    //                categories[event.eventCategory] = 1
    //            }
    //        }
    //    }
}

