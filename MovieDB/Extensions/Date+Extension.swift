//
//  Date+Extension.swift
//  MovieDB
//
//  Created by Suhit Patil on 17/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.dateStyle = .medium
        let string = formatter.string(from: self)
        return string
    }
}
