//
//  NewEventView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData

struct NewEventView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) private var viewContext
  
  @ObservedObject private var viewModel: NewEventViewModel
  
  private enum Field: Int, Hashable {
    case experience
    case feelings
    case moods
    case thoughts
    case thoughtsWriting
  }
  
  @FocusState private var focusedField: Field?
  
  init(pleasant: Bool, context: NSManagedObjectContext) {
    viewModel = NewEventViewModel(pleasant: pleasant, context: context)
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Group {
          Text("What was the experience?")
          TextField("Your experience", text: $viewModel.experience)
            .focused($focusedField, equals: .experience)
            .onAppear {
              focusedField = .experience
            }
          }
          
          Toggle("Were you aware of the \(viewModel.pleasant ? "pleasant" : "unpleasant") feelings while the event was happening?", isOn: $viewModel.aware)
            .padding(.top)
          
          Text("How did your body feel, in detail, during this experience?")
            .padding(.top)
          TextField("", text: $viewModel.feelings)
          
          Text("What moods and emotions were present?")
          TextField("", text: $viewModel.moods)
          
          Text("What thoughts were present?")
            .padding(.top)
          TextField("", text: $viewModel.thoughts)
          
          Text("What thoughts are here as you write this down now?")
            .padding(.top)
          TextField("", text: $viewModel.thoughtsWriting)
        }
        
        Button("Save", action: save)
          .keyboardShortcut(.defaultAction)
          .disabled(viewModel.saveButtonDisabled)
      }
      .navigationTitle("New \(viewModel.pleasant ? "Pleasant" : "Unpleasant") Event")
      .toolbar {
        ToolbarItem {
          Button(action: closeWindow) {
            Label("Cancel", systemImage: "xmark")
          }
        }
      }
    }
  }
  
  private func save() {
    withAnimation {
      viewModel.save {
        closeWindow()
      }
    }
  }
  
  private func closeWindow() {
    presentationMode.wrappedValue.dismiss()
  }
}

struct NewEventView_Previews: PreviewProvider {
  static var previews: some View {
    NewEventView(pleasant: true, context: PersistenceController.shared.container.viewContext)
      .navigationViewStyle(StackNavigationViewStyle())
  }
}
