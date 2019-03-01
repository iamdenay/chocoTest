import Foundation
import ObjectMapper

class Response : Mappable {
    
    // API returns object instead of array of BPIs
    // So I'm wrapping my [BPI] array in Response object
    
    var usd: RealtimeBPI?
    var gbp: RealtimeBPI?
    var eur: RealtimeBPI?
    
    // API returns only predefined objects
    // I need custom array of BPI objects if there will be
    // new currencies in future
    
    var results:[RealtimeBPI]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        usd <- map["USD"]
        gbp <- map["GBP"]
        eur <- map["EUR"]
        results = [RealtimeBPI]()
        // TODO: nil check
        results?.append(usd!)
        results?.append(gbp!)
        results?.append(eur!)
        
    }
}
