
import Foundation
import ObjectMapper

class RealtimeBPI : Mappable {
    
    // This entity is wrapped in Response class
    
    var code:String?
    var symbol:String?
    var rate:String?
    var description:String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        code <- map["code"]
        symbol <- map["symbol"]
        rate <- map["rate"]
        description <- map["description"]
        symbol = symbol!.html2String
    }
}


