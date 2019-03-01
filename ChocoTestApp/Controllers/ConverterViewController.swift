
import UIKit
import Sugar
import EasyPeasy
import Reusable
import Tactile
import SVProgressHUD
import ChameleonFramework
import SwiftChart

class ConverterViewController: BaseViewController, CurrencyPickerViewDelegate  {
    
    // Custom UIView for showing and selecting Currency
    fileprivate lazy var picker : CurrencyPickerView = {
        return CurrencyPickerView().then {
            $0.delegate = self
        }
    }()
    
    fileprivate var currency = "USD"
    fileprivate var price = 0.0
    
    fileprivate lazy var btcLabel = UILabel().then {
        $0.textColor = Settings.textColor
        $0.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "BTC"
        $0.adjustsFontSizeToFitWidth = true
        $0.contentScaleFactor = 0.1
    }
    
    fileprivate lazy var btcTextField: UITextField = UITextField().then {
        $0.placeholder = "0.1 BTC"
        $0.textColor = Settings.textColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        $0.addTarget(self, action: #selector(btcDidChange), for: .editingChanged)
        $0.adjustsFontSizeToFitWidth = true
        $0.contentScaleFactor = 0.1
    }
    
    fileprivate lazy var curLabel = UILabel().then {
        $0.textColor = Settings.textColor
        $0.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "PICK"
        $0.adjustsFontSizeToFitWidth = true
        $0.contentScaleFactor = 0.1
    }
    
    fileprivate lazy var curTextField: UITextField = UITextField().then {
        $0.placeholder = "300 \(self.currency)"
        $0.textColor = Settings.textColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        $0.addTarget(self, action: #selector(curDidChange), for: .editingChanged)
        $0.adjustsFontSizeToFitWidth = true
        $0.contentScaleFactor = 0.1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func loadData(){
        SVProgressHUD.show()
        BPIRepository().getRealtime(){ res in
            SVProgressHUD.dismiss()
            if let results = res.results {
                self.picker.currencies = results
            }
        }
    }
    
    fileprivate func configureViews(){
        navigationItem.title = "Converter"
        view.addSubviews(picker, btcLabel, btcTextField, curLabel, curTextField)
    }
    
    
    fileprivate func configureConstraints(){
        let screenSize: CGRect = UIScreen.main.bounds
        picker.easy.layout(
            Top(16),
            Left(16),
            Right(16),
            Height(screenSize.height * 0.33)
        )
        
        btcLabel.easy.layout(
            Top(36).to(picker, .bottom),
            Left(32),
            Right(32).to(curLabel, .left),
            Width().like(curLabel)
        )
        
        btcTextField.easy.layout(
            Top(36).to(btcLabel, .bottom),
            Left(32),
            Right(32).to(curTextField, .left),
            Width().like(curTextField)
        )
        
        curLabel.easy.layout(
            Top(36).to(picker, .bottom),
            Right(32),
            Left(32).to(btcLabel, .right)
        )
        
        curTextField.easy.layout(
            Top(36).to(curLabel, .bottom),
            Right(32),
            Left(32).to(btcTextField, .right)
        )
    }
    
    func onChange(_ selected: String, _ price:Double ) {
        self.currency = selected
        self.price = price
        self.curLabel.text = selected
        self.curTextField.placeholder = "300 \(self.currency)"
        self.btcDidChange()
    }
    
    @objc func curDidChange() {
        self.curTextField.text = self.curTextField.text!.filter("01234567890.".contains)
        let amount = Double(curTextField.text!) ?? 0
        let price = Double(self.price) ?? 0
        print(amount)
        print(price)
        let sum = round(100*(amount / price))/100
        self.btcTextField.text = String(describing: sum)
        
    }
    
    @objc func btcDidChange() {
        self.btcTextField.text = self.btcTextField.text!.filter("01234567890.".contains)
        let amount = Double(btcTextField.text!) ?? 0
        let price = Double(self.price) ?? 0
        print(amount)
        print(price)
        let sum = round(100*(amount * price))/100
        self.curTextField.text = String(describing: sum)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = +49
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if btcTextField.isFirstResponder || curTextField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height+49
            }
        }
    }
}

