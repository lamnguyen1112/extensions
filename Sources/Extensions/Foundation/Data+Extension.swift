//
//  Data+Extension.swift
//  
//
//  Created by Lam Nguyen on 4/25/22.
//

import Foundation

public extension Data {
    func deviceTokenString() -> String {
        let tokenParts = self.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        return tokenParts.joined()
    }

    var stringUTF8: String? { return String(data: self, encoding: .utf8) }
}

public extension Data {
//    var html2AttributedString: NSAttributedString? {
//        do {
//            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            print("error:", error)
//            return  nil
//        }
//    }
//    
//    var html2String: String { html2AttributedString?.string ?? "" }
}
