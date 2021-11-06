//
//  CoreDataStorage.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import Foundation
import CoreData
import Combine

// https://www.donnywals.com/observing-changes-to-managed-objects-across-contexts-with-combine/

class CoreDataStorage {
  // configure and create persistent container
  // viewContext.automaticallyMergesChangesFromParent is set to true
  
  func publisher<T: NSManagedObject>(for managedObject: T,
                                     in context: NSManagedObjectContext) -> AnyPublisher<T, Never> {
//    let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
    let notification = NSManagedObjectContext.didSaveObjectIDsNotification
    return NotificationCenter.default.publisher(for: notification, object: context)
      .compactMap { notification in
        if let updated = notification.userInfo?[NSUpdatedObjectIDsKey] as? Set<NSManagedObjectID>,
           updated.contains(managedObject.objectID),
           let updatedObject = context.object(with: managedObject.objectID) as? T {
          
          return updatedObject
        } else {
          return nil
        }
      }
      .eraseToAnyPublisher()
  }
}
