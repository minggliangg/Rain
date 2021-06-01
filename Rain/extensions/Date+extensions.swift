//
//  Date+extensions.swift
//  Rain
//
//  Created by Ming Liang Khong on 1/6/21.
//

import Foundation

extension Date {
    
    /// Returns the date in the ISO 8601 Format ( yyyy-MM-dd'T'HH:mm:ss )
    var ISO8601Format:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
