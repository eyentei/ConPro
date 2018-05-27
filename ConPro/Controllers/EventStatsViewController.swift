//
//  EventStatsViewController.swift
//  ConPro
//
//  Created by Anton Danilov on 25.05.2018.
//  Copyright © 2018 ConPro. All rights reserved.
//
import UIKit
import Charts


class EventStatsViewController: UIViewController {
    
    @IBOutlet weak var totalSubsLabel: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var segCintrol: UISegmentedControl!
    
    var selectedEvent: Event?
    
    var ageView: HorizontalBarChartView!
    var genderView: PieChartView!
    var educationView: PieChartView!
    var subs : Int = 100
    var subsAgeValues : [Int] = [1,2,3,4]
    let subsAgeLabels = ["13-17","18-24","25-34","35-44+"]
    var subsGenderValues : [Int] = [2,6]
    let subsGenderLabels = ["male","female"]
    var subsEducationValues : [Int] = [3,6,8]
    let subsEducationLabels = ["kid","student","specialist"]
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            updateGenderChartView()
            self.genderView.alpha = 1
            self.ageView.alpha = 0
            self.educationView.alpha = 0
            break
        case 1:
            updateAgeChartView()
            self.genderView.alpha = 0
            self.ageView.alpha = 1
            self.educationView.alpha = 0
            break
        case 2:
            updateEducationChartView()
            self.genderView.alpha = 0
            self.ageView.alpha = 0
            self.educationView.alpha = 1
            break
        default:
            self.genderView.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageView = AgeViewController().view as! HorizontalBarChartView?
        ageView.frame.size = viewContainer.frame.size
        
        genderView = GenderViewController().view as! PieChartView?
        genderView.frame.size = viewContainer.frame.size
        
        educationView = EducationViewController().view as! PieChartView?
        educationView.frame.size = viewContainer.frame.size
        
        viewContainer.addSubview(ageView)
        viewContainer.addSubview(genderView)
        viewContainer.addSubview(educationView)
        viewContainer.autoresizesSubviews = true
        viewContainer.sizeToFit()
        ageView.translatesAutoresizingMaskIntoConstraints = false
        
//        let user1 = User()
//        user1.age = 13
//        user1.post = "student"
//        user1.gender = "male"
//        let user2 = User()
//        user2.age = 33
//        user2.post = "specialist"
//        user2.gender = "female"
//        let user3 = User()
//        user3.age = 27
//        user3.post = "student"
//        user3.gender = "male"
//        selectedEvent!.visitors.append(user1)
//        selectedEvent!.visitors.append(user2)
//        selectedEvent!.visitors.append(user3)
        
//        getSubsStats()
        
        
        totalSubsLabel.text = "Total Subs:\(subs)"
        updateGenderChartView()
        self.genderView.alpha = 1
        self.ageView.alpha = 0
        self.educationView.alpha = 0
        
    }
    func updateAgeChartView() {
        
        //        var ageArray = subsAgeValues.filter{$0 != 0}
        //        let ageValues : Int
        //        let ageLabels :
        //        for age in subsAgeValues{
        //            if age == 0
        //            {
        //                var index =
        //            }
        //        }
        
        
        
        var dataAges = [ChartDataEntry]()
        
        for i in 0..<subsAgeValues.count {
            let entry = BarChartDataEntry(x: Double(i), y: Double(subsAgeValues[i]))
            dataAges.append(entry)
        }
        let barChartDataSet = BarChartDataSet(values: dataAges, label: nil)
        barChartDataSet.valueColors = [NSUIColor.groupTableViewBackground]
        barChartDataSet.drawValuesEnabled = true
        if #available(iOS 11.0, *) {
            barChartDataSet.colors = [UIColor(named: "Color-1"), UIColor(named: "Color-2"),UIColor(named: "Color-3"),UIColor(named: "Color-4")] as! [NSUIColor]
        } else {
            barChartDataSet.colors = ChartColorTemplates.joyful()
        }
        
        
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setDrawValues(true)
        barChartData.setValueTextColor(NSUIColor.groupTableViewBackground)
        
        
        ageView.chartDescription?.text = ""
        ageView.legend.enabled = false
        
        ageView.xAxis.gridColor = NSUIColor.groupTableViewBackground
        ageView.xAxis.axisLineColor = NSUIColor.groupTableViewBackground
        ageView.rightAxis.labelTextColor = NSUIColor.groupTableViewBackground
        ageView.leftAxis.labelTextColor = NSUIColor.groupTableViewBackground
        
        
        ageView.xAxis.valueFormatter = IndexAxisValueFormatter(values: subsAgeLabels)
        ageView.xAxis.granularityEnabled = true
        ageView.xAxis.granularity = 1
        
        
        ageView.xAxis.labelPosition = .bottomInside
        ageView.xAxis.drawGridLinesEnabled = false
        
        
        ageView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        
        ageView.data = barChartData
        
    }
    func updateGenderChartView() {
        var dataSex = [PieChartDataEntry]()
        for i in 0..<subsGenderValues.count{
            let entry = PieChartDataEntry(value: Double(subsGenderValues[i]))
            entry.label = subsGenderLabels[i]
            dataSex.append(entry)
        }
        let pieChartDataSet = PieChartDataSet(values: dataSex, label: nil)
        
        if #available(iOS 11.0, *) {
            pieChartDataSet.colors = [UIColor(named: "Color-1"),UIColor(named: "Color-4")] as! [NSUIColor]
        } else {
            pieChartDataSet.colors = ChartColorTemplates.joyful()
        }
        
        pieChartDataSet.valueTextColor = UIColor.black
        pieChartDataSet.selectionShift = 0
        let chartData = PieChartData(dataSet: pieChartDataSet)
        
        genderView.chartDescription?.text = ""
        
        genderView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        genderView.holeRadiusPercent = 0
        genderView.transparentCircleRadiusPercent = 0
        genderView.legend.enabled = false
        genderView.minOffset = 0
        
        genderView.data = chartData
    }
    func updateEducationChartView() {
        
        var dataEducation = [PieChartDataEntry]()
        for i in 0..<subsEducationValues.count{
            let entry = PieChartDataEntry(value: Double(subsEducationValues[i]))
            entry.label = subsEducationLabels[i]
            dataEducation.append(entry)
        }
        let pieChartDataSet = PieChartDataSet(values: dataEducation, label: nil)
        
        if #available(iOS 11.0, *) {
            pieChartDataSet.colors = [UIColor(named: "Color-2"),UIColor(named: "Color-3"),UIColor(named: "Color-4")] as! [NSUIColor]
        } else {
            pieChartDataSet.colors = ChartColorTemplates.joyful()
        }
        
        pieChartDataSet.valueTextColor = UIColor.black
        pieChartDataSet.selectionShift = 0
        let chartData = PieChartData(dataSet: pieChartDataSet)
        
        educationView.chartDescription?.text = ""
        
        educationView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        educationView.holeRadiusPercent = 0
        educationView.transparentCircleRadiusPercent = 0
        educationView.legend.enabled = false
        educationView.minOffset = 0
        
        educationView.data = chartData
        
    }
    func getSubsStats(){
        //        subsAgeValues.removeAll()
        //        subsGenderValues.removeAll()
        //        subsEducationValues.removeAll()
        
        for sub in selectedEvent!.visitors
        {
            if sub.age >= 13 || sub.age <= 17 {subsAgeValues[0] = subsAgeValues[0] + 1}
            if sub.age > 24 || sub.age <= 34 {subsAgeValues[2]+=1}
            if sub.age > 34{subsAgeValues[3]+=1}
            if sub.gender == "male" {subsGenderValues[0]+=1}
            if sub.gender == "female" {subsGenderValues[1]+=1}
            if sub.post == "student"{subsEducationValues[0]+=1}
            if sub.post == "schoolkid"{subsEducationValues[1]+=1}
            if sub.post == "specialist"{subsEducationValues[2]+=1}
        }
    }
}

