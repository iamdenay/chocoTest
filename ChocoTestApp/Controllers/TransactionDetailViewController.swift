
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
    fileprivate lazy var priceLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        if let price = transaction?.price{
            $0.text = price
        }
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
    fileprivate lazy var tidLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        if let tid = transaction?.tid{
            $0.text = String(describing: tid)
        }
    }
    fileprivate lazy var sumLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
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
        view.addSubviews(typeLabel, amountLabel, priceLabel, dateLabel, tidLabel, sumLabel)
    }
    
    fileprivate func configureConstraints(){
        tidLabel.easy.layout(
            Center()
        )
        amountLabel.easy.layout(
            Top(4).to(tidLabel, .bottom),
            CenterX()
        )
        priceLabel.easy.layout(
            Top(4).to(amountLabel, .bottom),
            CenterX()
        )
        dateLabel.easy.layout(
            Top(4).to(priceLabel, .bottom),
            CenterX()
        )
        typeLabel.easy.layout(
            Top(4).to(dateLabel, .bottom),
            CenterX()
        )
        sumLabel.easy.layout(
            Top(4).to(typeLabel, .bottom),
            CenterX()
        )
    }
}

