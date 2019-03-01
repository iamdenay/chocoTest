
import Foundation
import Alamofire
import AlamofireObjectMapper

class BPIRepository {
    
    let bpiURL = Settings.bpiURL
    
    func getTransactions(completion: @escaping ([Transaction]) -> ()){
        
        let reqURL = Settings.transURL
        
        Alamofire.request(reqURL).responseArray { (response: DataResponse<[Transaction]>) in
            print("Request: \(String(describing: response.request!))")
            print("Response: \(String(describing: response.response!))")
            print("Error: \(String(describing: response.error))")
            print("Result: \(response.result)")
            
            if let res = response.result.value {
                print("transactions")
                completion(res)
            }
        }
    }
    
    func getRealtime(completion: @escaping (Response) -> ()){
        
        let reqURL = bpiURL + "currentprice.json"
        
        Alamofire.request(reqURL).responseObject(keyPath:"bpi") { (response: DataResponse<Response>) in
            print("Request: \(String(describing: response.request!))")
            print("Response: \(String(describing: response.response!))")
            print("Error: \(String(describing: response.error))")
            print("Result: \(response.result)")
            
            if let res = response.result.value {
                print("realtime")
                completion(res)
            }
        }
    }
    
    func getSeries(period:Int, currency:String, completion: @escaping ([(x:Double, y:Double)]) -> ()){
        let start = getEndDate(period)
        let end = getEndDate(0)
        let reqURL = bpiURL + "historical/close.json"
        let parameters: Parameters = [
            "start": start,
            "currency": currency,
            "end": end
        ]
        
        Alamofire.request(reqURL, parameters:parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                var arr = [(x:Double, y:Double)]()
                let resp = json as! NSDictionary
                let bpi = resp["bpi"] as! NSDictionary
                switch period {
                case 1:
                    arr = self.getResultForWeek(bpi: bpi)
                case 2:
                    arr = self.getResultForMonth(bpi: bpi)
                case 3:
                    arr = self.getResultForYear(bpi: bpi)
                default:
                    print("def")
                }
                completion(arr)
            }
        }
    }
    
    func getResultForWeek(bpi:NSDictionary) -> [(x:Double, y:Double)] {
        var arr = [(x:Double, y:Double)]()
        for(x,y) in bpi {
            let date: String = String(describing: x)
            let rate: Double = Double(String(describing: y))!
            let day = Double(date.split("-")[2])
            arr.append((x:day!, y:rate))
        }
        let sorted = arr.sorted(by: {$0.x < $1.x})
        return sorted
    }
    // API results only daily info, so we need to calculate average rate by weeks
    func getResultForMonth(bpi:NSDictionary) -> [(x:Double, y:Double)] {
        print(bpi)
        var arr = [(x:Double, y:Double)]()
        var weeks = [0.0,0.0,0.0,0.0,0.0]
        var days = [0.0,0.0,0.0,0.0,0.0]
        var count = 0
        let sortedKeys = Array(bpi.allKeys).sorted(by: {String(describing: $0) < String(describing: $1)})
        for key in sortedKeys {
            var doubleRate : Double = 0.0
            let date = key as! String
            let rate = String(describing: bpi[date]!)
            doubleRate = rate.toDouble() ?? 0
            if 0...7 ~= count {
                weeks[0] += doubleRate / 7
            } else if 7...14 ~= count {
                weeks[1] += doubleRate / 7
            } else if 14...21 ~= count {
                weeks[2] += doubleRate / 7
            } else {
                weeks[3] += doubleRate / 9
            }
            count += 1
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = (sortedKeys.last as! String)
        let today = df.date(from: date)
        for week in 1...4 {
            let res = Calendar.current.date(byAdding: .day, value: -7 * (4-week), to: today!)!
            days[week-1] = Double(res.day)
        }
        arr.append((x:days[0], y:weeks[0]))
        arr.append((x:days[1], y:weeks[1]))
        arr.append((x:days[2], y:weeks[2]))
        arr.append((x:days[3], y:weeks[3]))
        
        return arr
    }
    
    // API results only daily info, so we need to calculate average rate by months
    func getResultForYear(bpi:NSDictionary) -> [(x:Double, y:Double)] {
        print(bpi)
        var arr = [(x:Double, y:Double)]()
        var months = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        let sortedKeys = Array(bpi.allKeys).sorted(by: {String(describing: $0) < String(describing: $1)})
        for key in sortedKeys {
            var doubleRate : Double = 0.0
            let date = key as! String
            let rate = String(describing: bpi[date]!)
            doubleRate = rate.toDouble() ?? 0
            let month = Double(date.split("-")[1])
            months[Int(month!-1)] += doubleRate / 30
        }
        for m in 1...12 {
            arr.append((x:Double(m), y:months[m-1]))
        }
        
        return arr
    }
    
    func getEndDate(_ period: Int) -> String{
        var res = Date()
        switch period {
        case 1:
            res = Calendar.current.date(byAdding: .day, value: -7, to: res)!
        case 2:
             res = Calendar.current.date(byAdding: .month, value: -1, to: res)!
        case 3:
             res = Calendar.current.date(byAdding: .year, value: -1, to: res)!
        default:
            res = Calendar.current.date(byAdding: .day, value: 1, to: res)!
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: res)
    }
    
}
