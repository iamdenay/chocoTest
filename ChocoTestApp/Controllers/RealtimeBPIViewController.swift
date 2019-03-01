//
//  ViewController.swift
//  mvvm
//
//  Created by Atabay Ziyaden on 9/27/18.
//  Copyright © 2018 IcyFlame Studios. All rights reserved.
//

import UIKit
import Sugar
import EasyPeasy
import Reusable
import Tactile
import SVProgressHUD
import ChameleonFramework
import SwiftChart

class RealtimeBPIViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let maxNumber = 3
    fileprivate var currencies = [RealtimeBPI]() {
        didSet {
            tableView.reloadData()
        }
    }
    fileprivate var currency = "USD"{
        didSet {
            loadChart(period, currency)
        }
    }
    fileprivate var period = 1 {
        didSet {
            loadChart(period, currency)
        }
    }
    fileprivate let chart : Chart = Chart()
    fileprivate var control : UISegmentedControl =  {
        let preiods  = ["Week", "Month", "Year"]
        return UISegmentedControl(items:preiods).then {
            $0.selectedSegmentIndex = 0
            $0.addTarget(self, action: #selector(changePeriod), for: .valueChanged)
            $0.layer.cornerRadius = 5.0
            $0.tintColor = UIColor.flatBlack
        }
    }()

    fileprivate lazy var tableView: UITableView = {
        return UITableView().then {
            $0.register(cellType: BPICell.self)
            $0.dataSource = self
            $0.delegate = self
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.allowsMultipleSelection = false
            $0.backgroundColor = .clear
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        loadData()
    }
    
    fileprivate func loadData(){
        SVProgressHUD.show()
        BPIRepository().getRealtime(){ res in
            SVProgressHUD.dismiss()
            if let results = res.results {
                self.currencies = results
                self.loadChart(self.period, self.currency)
            }
        }
    }
    
    fileprivate func configureViews(){
        navigationItem.title = "Realtime BPI"
        view.addSubviews(tableView, chart, control)
        chart.xLabelsSkipLast = false
    }
    

    fileprivate func configureConstraints(){
        tableView.easy.layout(
            Top(16),
            Left(16),
            Right(16),
            Height(220)
        )
        
        chart.easy.layout(
            Left(20),
            Right(20),
            Top(16).to(tableView, .bottom),
            Bottom(16).to(control, .top)
        )
        
        control.easy.layout(
            Left(16),
            Right(16),
            Top(16).to(chart, .bottom),
            Bottom(16)
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as BPICell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.configure(data: currencies[indexPath.row])
        if(indexPath.row == 0) {
            cell.isSelected = true
            cell.toggleSelection()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BPICell
        for cell in tableView.visibleCells{
            cell.isSelected = false
            (cell as! BPICell).toggleSelection()
        }
        cell.toggleSelection()
        self.currency = cell.currency
        print(self.currency)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BPICell
        cell.toggleSelection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 3
    }
    
    @objc func changePeriod(sender: UISegmentedControl) {
        print("Changing Color to \(sender.selectedSegmentIndex)")
        self.period = sender.selectedSegmentIndex + 1
    }
    
    func loadChart(_ period:Int, _ currency:String){
        SVProgressHUD.show()
        BPIRepository().getSeries(period: period, currency: currency) { res in
            print("res here")
            self.chart.removeAllSeries()
            let series = ChartSeries(data: res)
            series.area = true
            series.color = .flatYellow
            self.chart.add(series)
            SVProgressHUD.dismiss()
        }
    }
    
}

