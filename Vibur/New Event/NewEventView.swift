//
//  NewEventView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData

enum Field: Int, Hashable {
  case experience
  case feelings
  case moods
  case thoughts
  case thoughtsWriting
}

struct NewEventView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) private var context
  
  @ObservedObject private var viewModel: NewEventViewModel
  
  @FocusState private var focusedField: Field?
  
  private let textFieldSpacing: CGFloat = 7
  
  init(pleasant: Bool, context: NSManagedObjectContext, event: Event? = nil) {
    viewModel = NewEventViewModel(pleasant: pleasant, context: context, event: event)
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          
          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("What was the experience?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .experience
              }
            
            ViburTextEditor(text: $viewModel.experience,
                            focusedField: _focusedField,
                            field: .experience)
          }
          
          Toggle(isOn: $viewModel.aware) {
            Text("Were you aware of the \(viewModel.pleasant ? "pleasant" : "unpleasant") feelings while the event was happening?")
              .font(.subheadline)
          }
          
          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("How did your body feel, in detail, during this experience?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .feelings
              }
            
            ViburTextEditor(text: $viewModel.feelings,
                            focusedField: _focusedField,
                            field: .feelings)
          }

          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("What moods and emotions were present?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .moods
              }
            
            ViburTextEditor(text: $viewModel.moods,
                            focusedField: _focusedField,
                            field: .moods)
          }
          
          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("What thoughts were present?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .thoughts
              }
            
            ViburTextEditor(text: $viewModel.thoughts,
                            focusedField: _focusedField,
                            field: .thoughts)
          }
          
          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("What thoughts are here as you write this down now?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .thoughtsWriting
              }
            
            ViburTextEditor(text: $viewModel.thoughtsWriting,
                            focusedField: _focusedField,
                            field: .thoughtsWriting)
          }
          
          Button(action: save) {
            HStack {
              Spacer()
              Text("Save")
              Spacer()
            }
          }
          .keyboardShortcut(.defaultAction)
          .disabled(viewModel.saveButtonDisabled)
          .buttonStyle(.borderedProminent)
          .controlSize(.large)
        }
        .padding()
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          focusedField = .experience
        }
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
    Group {
      NewEventView(pleasant: true, context: PersistenceController.shared.container.viewContext)
        .previewDevice("iPhone 13 Pro")
        .navigationViewStyle(StackNavigationViewStyle())
      
      NewEventView(pleasant: true, context: PersistenceController.shared.container.viewContext)
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 13 Pro")
        .navigationViewStyle(StackNavigationViewStyle())
      
      NewEventView(pleasant: true, context: PersistenceController.shared.container.viewContext)
        .previewDevice("iPad Pro (11-inch) (3rd generation)")
        .navigationViewStyle(StackNavigationViewStyle())
.previewInterfaceOrientation(.landscapeLeft)
    }
  }
}
