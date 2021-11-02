//
//  NewEventViewModel.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 01/11/2021.
//

import SwiftUI
import Combine
import CoreData

class NewEventViewModel: ObservableObject {
  @Published var experience = ""
  @Published var aware = false
  @Published var feelings = ""
  @Published var moods = ""
  @Published var thoughts = ""
  @Published var thoughtsWriting = ""
  
  @Published var saveButtonDisabled = true
  
  let pleasant: Bool
  
  private var anyCancellables = Set<AnyCancellable>()
  
  private let context: NSManagedObjectContext
  
  
  
  init(pleasant: Bool, context: NSManagedObjectContext) {
    self.context = context
    self.pleasant = pleasant
    
    setupListeners()
  }
  
  private func setupListeners() {
    Publishers.CombineLatest4(
        $experience.map(\.isNotEmpty),
        $feelings.map(\.isNotEmpty),
        $moods.map(\.isNotEmpty),
        $thoughts.map(\.isNotEmpty)
      )
      .map { $0 && $1 && $2 && $3 }
      .combineLatest($thoughtsWriting.map(\.isNotEmpty))
      .map {
        !($0 && $1)
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] empty in
        self?.saveButtonDisabled = empty
      }
      .store(in: &anyCancellables)
  }
  
  func save(completion: () -> ()) {
    let event = Event(context: context)
    event.timestamp = Date()
    event.pleasant = pleasant
    event.experience = experience
    event.aware = aware
    event.feelings = feelings
    event.moods = moods
    event.thoughts = thoughts
    event.thoughtsWriting = thoughtsWriting
    
    do {
      try context.save()
      completion()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}
