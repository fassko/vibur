//
//  EventsListViewModel.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import Foundation
import CoreData
import Combine
import UIKit

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
  
  func generateCSV(completion: @escaping (URL) -> Void) {
    var csvString = [
      "What was the experience?",
      "Were you aware of the \(self.pleasant ? "pleasant" : "unpleasant") feelings while the event was happening?",
      "How did your body feel, in detail, during this experience?",
      "What moods and emotions were present?",
      "What thoughts were present?",
      "What thoughts are here as you write this down now?"
    ].CSVData.appending("\n")
    
    let eventsCSVString = events.map {
      [
        $0.experience ?? "",
        $0.aware.description,
        $0.feelings ?? "",
        $0.moods ?? "",
        $0.thoughts ?? "",
        $0.thoughtsWriting ?? ""
      ].CSVData
    }.joined(separator: "\n")
    
    csvString.append(contentsOf: eventsCSVString)
    
    DispatchQueue.global(qos: .userInitiated).async {
      let fileManager = FileManager.default
      do {
        let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
        let formatter = DateFormatter()
        formatter.dateFormat = "DDMMYYYY.HHmmss"
        let fileName = "Vibur.\(formatter.string(from: Date())).csv"
        let fileURL = path.appendingPathComponent(fileName)
        try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        
        DispatchQueue.main.async {
          completion(fileURL)
        }
      } catch {
        print("error creating file")
        fatalError("error creating file")
      }
    }
  }
}
