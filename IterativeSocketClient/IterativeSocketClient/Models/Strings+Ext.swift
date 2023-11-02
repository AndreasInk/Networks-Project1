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
extension TimeInterval {
    static var random: TimeInterval {
        Date().addingTimeInterval(TimeInterval.random(in: -1...1)).timeIntervalSince1970
    }
}
