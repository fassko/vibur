//
//  Event+Extensions.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import Foundation
import CoreData

extension Event {
  static func fetchRequest(pleasant: Bool, ascending: Bool) -> NSFetchRequest<Event> {
    let request = Event.fetchRequest()
    
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Event.timestamp, ascending: ascending)]
    request.predicate = NSPredicate(format: "pleasant == %@", NSNumber(value: pleasant))
    
    return request
  }
}
