//
//  SettingsView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import SwiftUI
import UIKit
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
  @Published var showNotificationSettingsUI = false
  @Published var notificationTime: Date
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    notificationTime = UserDefaultsConfig.pushNotificationTime
    
    setupListeners()
  }
  
  func setupListeners() {
    $showNotificationSettingsUI
      .dropFirst()
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] showNotificationSettingsUI in
        if showNotificationSettingsUI {
          self?.checkNotificationSettings()
        } else {
          self?.removeNotifications()
        }
      }
      .store(in: &cancellables)
    
    $notificationTime
      .removeDuplicates()
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        UserDefaultsConfig.pushNotificationTime = $0
        self?.scheduleNotification()
      }
      .store(in: &cancellables)
  }
  
  
  func checkNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
      guard
        settings.authorizationStatus == .authorized ||
          settings.authorizationStatus == .provisional
      else {
        DispatchQueue.main.async { [weak self] in
          self?.showNotificationSettingsUI = false
        }
        self?.removeNotifications()
        return
      }
      
      DispatchQueue.main.async { [weak self] in
        self?.showNotificationSettingsUI = true
      }
      self?.scheduleNotification()
    }
  }
  
  private func authorizeNotifications() {
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error  in
        if granted {
          self?.showNotificationSettingsUI = true
        } else {
          print("Can't register for notifications \(String(describing: error?.localizedDescription))")
        }
      }
  }
  
  private func scheduleNotification() {
    removeNotifications()
    
    let sendingTime = UserDefaultsConfig.pushNotificationTime
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.hour, .minute], from: sendingTime)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    let content = UNMutableNotificationContent()
    content.title = "Vibur"
    content.body = "Please log your pleasant or unpleasant event"
    content.sound = .default
    content.categoryIdentifier = "eventsList"
    
    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: content,
      trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
      if error != nil {
        print("something went wrong")
      } else {
        UserDefaultsConfig.pushNotificationID = request.identifier
      }
    }
  }
  
  func removeNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}

struct SettingsView: View {
  @StateObject var settingsViewModel = SettingsViewModel()
  
  var body: some View {
    Form {
      Section("Status") {
        Toggle("Enable Notifications", isOn: $settingsViewModel.showNotificationSettingsUI)
      }
      
      if settingsViewModel.showNotificationSettingsUI {
        Section("Time") {
          DatePicker("Sending Time Every Day", selection: $settingsViewModel.notificationTime, displayedComponents: .hourAndMinute)
            .pickerStyle(.menu)
        }
      }
    }
    .onAppear {
      settingsViewModel.checkNotificationSettings()
    }
    .navigationTitle("Settings")
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SettingsView()
    }
  }
}
