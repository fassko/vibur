//
//  ViburApp.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI

@main
struct ViburApp: App {
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext,
                      persistenceController.container.viewContext)
    }
  }
}
