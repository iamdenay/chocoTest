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

protocol CurrencyPickerViewDelegate: class {
    func onChange(_ selected: String, _ price: Double)
}

class CurrencyPickerView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: CurrencyPickerViewDelegate?
    var maxNumber = 3
    var firstSelected = false
    var currency = "USD" {
        didSet {
            delegate?.onChange(currency, price)
        }
    }
    
    var price = 0.0 {
        didSet {
            delegate?.onChange(currency, price)
        }
    }
    
    var currencies = [RealtimeBPI]() {
        didSet {
            tableView.reloadData()
        }
    }

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureViews(){
        self.addSubview(tableView)
    }
    
    fileprivate func configureConstraints(){
        tableView.easy.layout(
            Edges()
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as BPICell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.configure(data: currencies[indexPath.row])
        if(indexPath.row == 0 ) {
            self.price = cell.price
            if (self.firstSelected){
                cell.isSelected = true
                cell.toggleSelection()
            }
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
        self.price = cell.price
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BPICell
        cell.toggleSelection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / CGFloat(maxNumber)
    }
}

