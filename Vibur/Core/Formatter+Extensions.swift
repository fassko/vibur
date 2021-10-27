//
//  Formatter+Extensions.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 26/10/2021.
//

import Foundation

extension Formatter {
  static var itemFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
  }
}
