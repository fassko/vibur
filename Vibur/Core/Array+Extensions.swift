//
//  Array+Extensions.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import Foundation

extension Array where Element == String {
  var CSVData: String {
    self
      .map { "\"\($0)\"" }
      .joined(separator: ",")
  }
}
