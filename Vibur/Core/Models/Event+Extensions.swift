//
//  Event+Extensions.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 01/11/2021.
//

import Foundation
import CoreData
import SwiftUI

extension Event {
  static func pleasantFetchRequest(pleasant: Bool) -> FetchRequest<Event> {
    FetchRequest(
      sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: true)],
      predicate: NSPredicate(format: "pleasant == %@", NSNumber(value: pleasant))
    )
  }
}
