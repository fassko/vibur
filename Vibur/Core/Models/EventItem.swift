//
//  EventItem.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 25/10/2021.
//

import Foundation
import CoreData

struct EventItem {
  let timestamp: Date
  let pleasant: Bool
  let experience: String
  let aware: Bool
  let feelings: String
  let moods: String
  let thoughts: String
  let thoughtsWriting: String
  
  init(event: Event) {
    self.timestamp = event.timestamp ?? Date()
    self.pleasant = event.pleasant
    self.experience = event.experience ?? ""
    self.aware = event.aware
    self.feelings = event.feelings ?? ""
    self.moods = event.moods ?? ""
    self.thoughts = event.thoughts ?? ""
    self.thoughtsWriting = event.thoughtsWriting ?? ""
  }
  
  init(timestamp: Date,
       pleasant: Bool,
       experience: String,
       aware: Bool,
       feelings: String,
       moods: String, thoughts: String,
       thoughtsWriting: String) {
    self.timestamp = timestamp
    self.pleasant = pleasant
    self.experience = experience
    self.aware = aware
    self.feelings = feelings
    self.moods = moods
    self.thoughts = thoughts
    self.thoughtsWriting = thoughtsWriting
  }
}

extension EventItem {
  static var mocked: EventItem {
    EventItem(timestamp: Date(),
              pleasant: true,
              experience: "My experience working on design",
              aware: true,
              feelings: "Excited and determined",
              moods: "Happy that I can do something",
              thoughts: "Look I can do design",
              thoughtsWriting: "Do I really know how to do it?")
  }
}
