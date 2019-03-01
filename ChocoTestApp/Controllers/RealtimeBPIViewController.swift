
import UIKit
import Sugar
import EasyPeasy
import Reusable
import Tactile
import SVProgressHUD
import ChameleonFramework
import SwiftChart

class RealtimeBPIViewController: BaseViewController, CurrencyPickerViewDelegate  {

    fileprivate let maxNumber = 3
    
    // Custom UIView for showing and selecting Currency
    fileprivate lazy var picker : CurrencyPickerView = {
        return CurrencyPickerView().then {
            $0.delegate = self
            $0.firstSelected = true
        }
    }()
    
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
                self.picker.currencies = results
                self.loadChart(self.period, self.currency)
            }
        }
    }
    
    fileprivate func configureViews(){
        navigationItem.title = "Realtime BPI"
        view.addSubviews(picker, chart, control)
        chart.xLabelsSkipLast = false
    }
    

    fileprivate func configureConstraints(){
        let screenSize: CGRect = UIScreen.main.bounds
        picker.easy.layout(
            Top(16),
            Left(16),
            Right(16),
            Height(screenSize.height * 0.33)
        )
        
        chart.easy.layout(
            Left(20),
            Right(20),
            Top(16).to(picker, .bottom),
            Bottom(16).to(control, .top)
        )
        
        control.easy.layout(
            Left(16),
            Right(16),
            Top(16).to(chart, .bottom),
            Bottom(16)
        )
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
    
    func onChange(_ selected: String, _ price:Double ) {
        self.currency = selected
    }
}

