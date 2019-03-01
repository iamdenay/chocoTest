
import UIKit
import EasyPeasy
import Sugar

class TransactionDetailViewController: BaseViewController {

    var transaction : Transaction?
    fileprivate var textClr = Settings.textColor
    
    fileprivate lazy var typeLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        if let type = transaction?.typeString{
            $0.text = type
            if type == "BUY" {
                $0.textColor = .flatGreen
            } else {
                $0.textColor = .flatRed
            }
        }
    }
    fileprivate lazy var amountLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        if let amount = transaction?.amount{
            $0.text = amount
        }
    }
    fileprivate lazy var priceNameLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "Purchase price"
        
    }
    fileprivate lazy var priceLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        if let price = transaction?.price{
            $0.text = price
        }
    }
    fileprivate lazy var bottomSeparator = UIView().then {
        $0.backgroundColor = UIColor(red: 0.46, green: 0.46, blue: 0.46, alpha: 0.1)
    }
    fileprivate lazy var dateNameLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "Date"
        
    }
    fileprivate lazy var dateLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        if let date = transaction?.date{
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            $0.text = df.string(from: date)
        }
    }
    fileprivate lazy var tidNameLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.text = "Transaction ID"
        
    }
    fileprivate lazy var tidLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        if let tid = transaction?.tid{
            $0.text = String(describing: tid)
        }
    }
    fileprivate lazy var sumNameLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "Total amount"
    }
    fileprivate lazy var sumLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        guard let price = transaction?.price, let amount = transaction?.amount else {
            return
        }
        var sum = round(100*(Double(price)! * Double(amount)!))/100
        $0.text = "\(sum) USD"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }
    
    
    fileprivate func configureViews(){
        view.addSubviews(typeLabel, amountLabel, priceLabel, priceNameLabel, dateLabel, dateNameLabel, tidLabel, tidNameLabel, sumLabel, sumNameLabel, bottomSeparator)
    }
    
    fileprivate func configureConstraints(){
        typeLabel.easy.layout(
            Top(40),
            CenterX()
        )
        amountLabel.easy.layout(
            Top(8).to(typeLabel, .bottom),
            CenterX()
        )
        bottomSeparator.easy.layout(
            Top(8).to(amountLabel, .bottom),
            Left(0),
            Right(0),
            Height(1)
        )
        tidNameLabel.easy.layout(
            Left(32),
            Top(8).to(bottomSeparator, .bottom)
        )
        tidLabel.easy.layout(
            Top(0).to(tidNameLabel, .top),
            Right(32)
        )
        priceNameLabel.easy.layout(
            Left(32),
            Top(8).to(tidLabel, .bottom)
        )
        priceLabel.easy.layout(
            Top(0).to(priceNameLabel, .top),
            Right(32)
        )
        dateNameLabel.easy.layout(
            Left(32),
            Top(8).to(priceLabel, .bottom)
        )
        dateLabel.easy.layout(
            Top(0).to(dateNameLabel, .top),
            Right(32)
        )
        sumNameLabel.easy.layout(
            Left(32),
            Top(8).to(dateLabel, .bottom)
        )
        sumLabel.easy.layout(
            Top(0).to(sumNameLabel, .top),
            Right(32)
        )
        
    }
}

