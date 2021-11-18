//
//  SettingsViewModel.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 18/11/2021.
//

import UIKit
import Combine

class SettingsViewModel: ObservableObject {
  @Published var notificationTime: Date
  @Published var notificationSettingsDisabledAlert = false
  @Published var notificationsEnabled = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    notificationTime = UserDefaultsConfig.pushNotificationTime
    
    setupListeners()
  }
  
  func checkNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
      guard
        settings.authorizationStatus == .authorized ||
          settings.authorizationStatus == .provisional
      else {
        DispatchQueue.main.async { [weak self] in
          self?.notificationsEnabled = false
        }
        
        self?.removeNotifications()
        return
      }
      
      DispatchQueue.main.async { [weak self] in
        self?.notificationsEnabled = true
      }
      self?.scheduleNotification()
    }
  }
  
  func authorizeNotifications() {
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error  in
        DispatchQueue.main.async {
          if granted {
            self?.notificationsEnabled = true
          } else {
            self?.notificationsEnabled = false
            self?.notificationSettingsDisabledAlert = true
            print("Can't register for notifications \(String(describing: error?.localizedDescription))")
          }
        }
      }
  }
  
  private func setupListeners() {
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
