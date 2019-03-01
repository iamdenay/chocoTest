import UIKit
import EasyPeasy
import Reusable
import Sugar

final class BPICell: UITableViewCell, Reusable {
    
    var currency = ""
    fileprivate var textClr = Settings.textColor
    fileprivate var container = UIView() // container for visible part

    fileprivate lazy var codeLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    fileprivate lazy var symbolLabel = UILabel().then {
        $0.textColor = textClr
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = false
        $0.lineBreakMode = NSLineBreakMode.byTruncatingTail
        $0.textAlignment = .left
    }
    
    fileprivate lazy var rateLabel = UILabel().then {
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
        self.container.addSubviews(codeLabel, symbolLabel, rateLabel)
        codeLabel.easy.layout(
            Left(16),
            Top(8)
        )
        
        symbolLabel.easy.layout(
            Left(0).to(codeLabel, .left),
            Top(2).to(codeLabel, .bottom),
            Bottom(8)
        )
        
        rateLabel.easy.layout(
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
    
    func configure(data:RealtimeBPI) {
        self.container.backgroundColor = .flatWhite // bg color of visible layer
        self.backgroundColor = .clear // invisible layer
        self.container.layer.cornerRadius = 15
        self.container.layer.masksToBounds = true
        
        if let code = data.code{
            self.codeLabel.text = code
            self.currency = code
        }
        if let symbol = data.symbol{
            self.symbolLabel.text = symbol
        }
        if let rate = data.rate{
            self.rateLabel.text = rate
        }
    }
    
    func toggleSelection(){
        if self.isSelected{
            self.container.backgroundColor = .flatYellow // if currency selected
        } else {
            self.container.backgroundColor = .flatWhite // bg color of visible layer
        }
    }
}





