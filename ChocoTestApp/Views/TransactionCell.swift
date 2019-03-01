import UIKit
import EasyPeasy
import Reusable
import Sugar

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
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = false
        $0.lineBreakMode = NSLineBreakMode.byTruncatingTail
        $0.textAlignment = .left
    }
    
    fileprivate lazy var amountLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .left
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
        self.container.addSubviews(amountLabel, typeLabel, dateLabel)
        typeLabel.easy.layout(
            Left(16),
            Top(8)
        )
        
        dateLabel.easy.layout(
            Left(0).to(typeLabel, .left),
            Top(2).to(typeLabel, .bottom),
            Bottom(8)
        )
        
        amountLabel.easy.layout(
            Right(16),
            CenterY()
        )
        container.easy.layout(
            Left(),
            Right(),
            Top(4),
            Bottom(4)
        )
    }
    
    func configure(transaction:Transaction) {
        self.transaction = transaction
        self.container.backgroundColor = .flatWhite // bg color of visible layer
        self.backgroundColor = .clear // invisible layer
        self.container.layer.cornerRadius = 15
        self.container.layer.masksToBounds = true
        
        if let type = transaction.typeString{
            self.typeLabel.text = type
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





