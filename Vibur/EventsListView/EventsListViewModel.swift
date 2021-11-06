//
//  EventsListViewModel.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import Foundation
import CoreData
import Combine

class EventsListViewModel: ObservableObject {
  @Published var events = [Event]()
  
  let pleasant: Bool
  
  private var anyCancellables = Set<AnyCancellable>()
  
  private let context: NSManagedObjectContext
  
  var ascending = false {
    didSet {
      loadData()
    }
  }
  
  init(pleasant: Bool, context: NSManagedObjectContext) {
    self.context = context
    self.pleasant = pleasant
    
    loadData()
  }
  
  func loadData() {
    let request = Event.fetchRequest(pleasant: pleasant,
                                     ascending: ascending)
    
    do {
      events = try context.fetch(request)
    } catch {
      print("Failed to fetch")
    }
  }
  
  func deleteItems(offsets: IndexSet) {
    offsets.map {
      events[$0]
    }.forEach(context.delete)
    
    do {
      try context.save()
      loadData()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}
