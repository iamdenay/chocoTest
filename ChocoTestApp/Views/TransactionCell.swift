import UIKit
import EasyPeasy
import Reusable
import Sugar
import ChameleonFramework

final class TransactionCell: UITableViewCell, Reusable {
    
    var transaction : Transaction?
    fileprivate var textClr = Settings.textColor
    fileprivate var container = UIView() // container for visible part
    
    fileprivate lazy var typeLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    fileprivate lazy var dateLabel = UILabel().then {
        $0.textColor = .flatGrayDark
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = false
        $0.lineBreakMode = NSLineBreakMode.byTruncatingTail
        $0.textAlignment = .left
    }
    
    fileprivate lazy var amountLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    fileprivate lazy var bottomSeparator = UIView().then {
        $0.backgroundColor = UIColor(red: 0.46, green: 0.46, blue: 0.46, alpha: 0.1)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureViews() {
        contentView.addSubviews(container)
    }
    
    fileprivate func configureConstraints() {
        self.container.addSubviews(amountLabel, typeLabel, dateLabel, bottomSeparator)
        typeLabel.easy.layout(
            Left(16),
            Top(8),
            Bottom(8).to(bottomSeparator, .top)
        )
        
        dateLabel.easy.layout(
            Left(0).to(typeLabel, .left),
            Top(8).to(bottomSeparator, .bottom),
            Bottom(8)
        )
        
        amountLabel.easy.layout(
            Top(8),
            Right(16),
            Bottom(8).to(bottomSeparator, .top)
        )
        container.easy.layout(
            Left(),
            Right(),
            Top(4),
            Bottom(4)
        )
        
        bottomSeparator.easy.layout(
            CenterY(),
            Left(0),
            Right(0),
            Height(1)
        )
    }
    
    func configure(transaction:Transaction) {
        self.transaction = transaction
        self.container.backgroundColor = .white // bg color of visible layer
        self.backgroundColor = .clear // invisible layer
        self.container.layer.cornerRadius = 8
        self.container.layer.masksToBounds = true
        
        if let type = transaction.typeString{
            self.typeLabel.text = type
            if type == "BUY"{
                self.typeLabel.textColor = .flatGreen
            } else {
                self.typeLabel.textColor = .flatRed
            }
        }
        if let date = transaction.date{
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.dateLabel.text = df.string(from: date)
        }
        if let amount = transaction.amount{
            self.amountLabel.text = amount
        }
    }
}





