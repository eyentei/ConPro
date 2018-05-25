//
//  EventStatsViewController.swift
//  ConPro
//
//  Created by Anton Danilov on 25.05.2018.
//  Copyright © 2018 ConPro. All rights reserved.
//
import UIKit
import Charts

@available(iOS 11.0, *)
class EventStatsViewController: UIViewController {
    
    @IBOutlet weak var totalSubsLabel: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var segCintrol: UISegmentedControl!
    
    var selectedEvent: Event?
    
    var ageView: HorizontalBarChartView!
    var genderView: PieChartView!
    var educationView: PieChartView!
    let colors = [UIColor(named: "Color-1"), UIColor(named: "Color-2"),UIColor(named: "Color-3"),UIColor(named: "Color-4")]
    let ageCount = [3, 6, 10, 12]
    let ageLabels = ["13-17","18-24","25-34","35-44+"]
    let sexCount = [30,70]
    let sexLabels = ["male","female"]
    let educationCount = [1,7,8]
    let educationLabels = ["kid","student","specialist"]
    let subs = 100
    
    
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
        
        
        
        totalSubsLabel.text = "Total Subs:\(subs)"
        updateGenderChartView()
        self.genderView.alpha = 1
        self.ageView.alpha = 0
        self.educationView.alpha = 0
        
    }
    func updateAgeChartView() {
        var dataAges = [ChartDataEntry]()
        
        for i in 0..<ageCount.count {
            let entry = BarChartDataEntry(x: Double(i), y: Double(ageCount[i]))
            dataAges.append(entry)
        }
        let barChartDataSet = BarChartDataSet(values: dataAges, label: nil)
        barChartDataSet.valueColors = [NSUIColor.groupTableViewBackground]
        barChartDataSet.drawValuesEnabled = true
        barChartDataSet.colors = colors as! [NSUIColor]
        
        
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.setDrawValues(true)
        barChartData.setValueTextColor(NSUIColor.groupTableViewBackground)
        
        
        ageView.chartDescription?.text = ""
        ageView.legend.enabled = false
        
        ageView.xAxis.gridColor = NSUIColor.groupTableViewBackground
        ageView.xAxis.axisLineColor = NSUIColor.groupTableViewBackground
        ageView.rightAxis.labelTextColor = NSUIColor.groupTableViewBackground
        ageView.leftAxis.labelTextColor = NSUIColor.groupTableViewBackground
        
        
        ageView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ageLabels)
        ageView.xAxis.granularityEnabled = true
        ageView.xAxis.granularity = 1
        
        
        ageView.xAxis.labelPosition = .bottomInside
        ageView.xAxis.drawGridLinesEnabled = false
        
        
        ageView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        
        ageView.data = barChartData
        
    }
    func updateGenderChartView() {
        var dataSex = [PieChartDataEntry]()
        for i in 0..<sexCount.count{
            let entry = PieChartDataEntry(value: Double(sexCount[i]))
            entry.label = sexLabels[i]
            dataSex.append(entry)
        }
        let pieChartDataSet = PieChartDataSet(values: dataSex, label: nil)
        
        pieChartDataSet.colors = [UIColor(named: "Color-1"),UIColor(named: "Color-4")] as! [NSUIColor]
        
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
        for i in 0..<educationCount.count{
            let entry = PieChartDataEntry(value: Double(educationCount[i]))
            entry.label = educationLabels[i]
            dataEducation.append(entry)
        }
        let pieChartDataSet = PieChartDataSet(values: dataEducation, label: nil)
        
        pieChartDataSet.colors = [UIColor(named: "Color-2"),UIColor(named: "Color-3"),UIColor(named: "Color-4")] as! [NSUIColor]
        
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
    
    
}
