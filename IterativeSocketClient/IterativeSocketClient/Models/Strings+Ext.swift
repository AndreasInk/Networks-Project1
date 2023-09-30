//
//  Strings+Ext.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 9/30/23.
//

import SwiftUI

extension String {
    static let statsWindow = "statsWindow"
}
extension Date {
    static var random: Date {
        Date().addingTimeInterval(TimeInterval.random(in: -3600...0))
    }
}
