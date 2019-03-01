
import UIKit
import Foundation
import ChameleonFramework

struct Settings {
    static var bpiURL = "https://api.coindesk.com/v1/bpi/"
    static var transURL = "https://www.bitstamp.net/api/transactions/"
    static var textColor = UIColor.flatBlack
    static var bgColor = UIColor.white
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
