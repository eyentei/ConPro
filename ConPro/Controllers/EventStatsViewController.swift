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
    var subsAgeValues : [Int] = [0,0,0,0]
    let subsAgeLabels = ["13-17","18-24","25-34","35-44+"]
    var subsGenderValues : [Int] = [0,0]
    let subsGenderLabels = ["male","female"]
    var subsEducationValues : [Int] = []
    var subsEducationLabels : [String] = []
    
    
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
        ageView.drawValueAboveBarEnabled = true
        getSubsStats()
        
        
        totalSubsLabel.text = "Total Subs:\(subs)"
        updateGenderChartView()
        self.genderView.alpha = 1
        self.ageView.alpha = 0
        self.educationView.alpha = 0
        
    }
    func updateAgeChartView() {
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
        barChartData.setValueTextColor(NSUIColor.groupTableViewBackground)
        barChartData.setValueFont(UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold))
        
        
        ageView.chartDescription?.text = ""
        ageView.legend.enabled = false
        
        ageView.xAxis.drawGridLinesEnabled = false
        
        ageView.xAxis.axisLineColor = NSUIColor.groupTableViewBackground
        ageView.rightAxis.labelTextColor = NSUIColor.groupTableViewBackground
        ageView.leftAxis.labelTextColor = NSUIColor.groupTableViewBackground
        ageView.leftAxis.axisMinimum = 0
        ageView.rightAxis.axisMinimum = 0
        ageView.leftAxis.drawGridLinesEnabled = false
        ageView.rightAxis.drawGridLinesEnabled = false
        ageView.leftAxis.drawAxisLineEnabled = false
        ageView.rightAxis.drawAxisLineEnabled = false
        ageView.leftAxis.drawTopYLabelEntryEnabled = true
        ageView.rightAxis.drawTopYLabelEntryEnabled = true
        ageView.leftAxis.drawBottomYLabelEntryEnabled = true
        ageView.rightAxis.drawBottomYLabelEntryEnabled = true
        ageView.rightAxis.drawLabelsEnabled = false
        ageView.leftAxis.drawLabelsEnabled = false
        
        ageView.xAxis.valueFormatter = IndexAxisValueFormatter(values: subsAgeLabels)
        
        
        
        ageView.xAxis.labelPosition = .bottom
        ageView.xAxis.labelTextColor = NSUIColor.groupTableViewBackground
        ageView.xAxis.labelFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
        //        ageView.xAxis.labelFont = NSUIFont.init(name: "Futura", size: 15.0)!
        ageView.xAxis.drawGridLinesEnabled = false
        ageView.xAxis.granularity = 1
        
        
        
        
        ageView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        
        barChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        ageView.drawValueAboveBarEnabled = true
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
        pieChartDataSet.entryLabelFont = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        pieChartDataSet.valueFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
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
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
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
        pieChartDataSet.entryLabelFont = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        pieChartDataSet.valueFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
        if #available(iOS 11.0, *) {
            pieChartDataSet.colors = [UIColor(named: "Color-1"),UIColor(named: "Color-2"),UIColor(named: "Color-3"),UIColor(named: "Color-4")] as! [NSUIColor]
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
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        educationView.data = chartData
        
        
    }
    func getSubsStats(){
        subsAgeValues = [0,0,0,0]
        subsGenderValues = [0,0]
        subsEducationValues = []
        var subPost = [String:Int]()
        let user1 = User()
        user1.post = "student"
        user1.gender = "male"
        user1.age = 14
        let user2 = User()
        user2.gender = "female"
        user2.post = "IT specilist"
        user2.age = 24
        let user3 = User()
        user3.post = "student"
        user3.gender = "male"
        user3.age = 34
        let user4 = User()
        user4.age = 17
        user4.post = "lawer"
        user4.gender = "male"
        let user5 = User()
        user5.age = 22
        user5.gender = "female"
        user5.post = "analyst"
        let user6 = User()
        user6.age = 22
        user6.gender = "female"
        user6.post = "analyst"
        let visitors = [user1,user2,user3,user4,user5,user6]
        
        for sub in visitors
        {
            if sub.age >= 13 && sub.age <= 17 {subsAgeValues[0]+=1}
            if sub.age > 17 && sub.age <= 24 {subsAgeValues[1]+=1}
            if sub.age > 24 && sub.age <= 34 {subsAgeValues[2]+=1}
            if sub.age > 34{subsAgeValues[3]+=1}
            if sub.gender == "male" {subsGenderValues[0]+=1}
            if sub.gender == "female" {subsGenderValues[1]+=1}
            if sub.post != " "{
                if subPost[sub.post] == nil{
                    subPost[sub.post] = 1
                }
                else {
                    subPost[sub.post] = subPost[sub.post]! + 1
                }
            }
        }
        
        subsEducationValues.append(contentsOf: subPost.values)
        subsEducationLabels.append(contentsOf: subPost.keys)
    }
}



