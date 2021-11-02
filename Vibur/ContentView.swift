//
//  ContentView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Event>
  
  private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom
  }
  
  private var isPortrait : Bool { UIDevice.current.orientation.isPortrait
  }
  
  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination: EventsListView(pleasant: false)) {
          Label("Unpleasant Events", systemImage: "minus.square")
        }
        
        NavigationLink(destination: EventsListView(pleasant: true)) {
          Label("Pleasant Events", systemImage: "plus.square")
        }
        
        NavigationLink(destination: AboutView()) {
          Label("About", systemImage: "info.circle")
        }
      }
      .listStyle(SidebarListStyle())
      .navigationTitle("Vibur")
      
      if !isPortrait {
        EmptyView()
        
        Text("Select what kind of events you would like to add.")
          .font(.title)
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
        .previewDevice("iPhone 13 Pro")
      
      ContentView()
        .previewDevice("iPad Pro (11-inch) (3rd generation)")
        .previewInterfaceOrientation(.landscapeRight)
    }
  }
}
