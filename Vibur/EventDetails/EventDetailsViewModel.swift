//
//  EventDetailsViewModel.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import Foundation
import CoreData
import Combine

class EventDetailsViewModel: ObservableObject {
  @Published var event: Event
  
  private var cancellables = Set<AnyCancellable>()
  
  private let context: NSManagedObjectContext
  
  private let storage: CoreDataStorage
  
  init(event: Event, context: NSManagedObjectContext, storage: CoreDataStorage) {
    self.event = event
    self.context = context
    self.storage = storage
    
    storage.publisher(for: event, in: context)
      .sink { [weak self] updatedObject in
        self?.event = updatedObject
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)
  }
}
