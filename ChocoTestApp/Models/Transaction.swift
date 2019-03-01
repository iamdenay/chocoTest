
import Foundation
import ObjectMapper

class Transaction : Mappable {
    
    var timestamp:String?
    var tid:Double?
    var price:String?
    var amount:String?
    var type:Int?
    var typeString:String?
    var date:Date?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        timestamp <- map["date"]
        tid <- map["tid"]
        price <- map["price"]
        amount <- map["amount"]
        type <- map["type"]
        if let timestamp = timestamp {
            date = Date(timeIntervalSince1970: Double(timestamp)!)
        }
        if type == 0 {
            typeString = "BUY"
        } else if type == 1 {
            typeString = "SELL"
        }
    }
}


