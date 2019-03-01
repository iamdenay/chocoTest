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

class TransactionsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate var transactions = [Transaction]() {
        didSet {
            tableView.reloadData()
        }
    }
 
    fileprivate lazy var tableView: UITableView = {
        return UITableView().then {
            $0.register(cellType: TransactionCell.self)
            $0.dataSource = self
            $0.delegate = self
            $0.rowHeight = 90
            $0.estimatedRowHeight = 90
            $0.separatorStyle = .none
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
        BPIRepository().getTransactions(){ res in
            SVProgressHUD.dismiss()
            self.transactions = res
        }
    }
    
    fileprivate func configureViews(){
        self.view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 240/255, alpha: 1)
        navigationItem.title = "Transactions for last hour"
        view.addSubview(tableView)
    }
    
    
    fileprivate func configureConstraints(){
        tableView.easy.layout(
            Edges(16)
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TransactionCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.configure(transaction: transactions[indexPath.row])
        cell.contentView.tap { tap in
            let vc = TransactionDetailViewController()
            vc.transaction = self.transactions[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true) as Any
        }
        return cell
    }
}

