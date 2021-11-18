//
//  SettingsView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import SwiftUI
import Combine
import UIKit

struct SettingsView: View {
  @StateObject var settingsViewModel = SettingsViewModel()
  
  var body: some View {
    Form {
      Section("Push Notifications") {
        if !settingsViewModel.notificationsEnabled {
          Button("Enable Push Notifications", action: settingsViewModel.authorizeNotifications)
        } else {
          
          DatePicker("Sending Time Every Day", selection: $settingsViewModel.notificationTime, displayedComponents: .hourAndMinute)
            .pickerStyle(.menu)
        }
      }
    }
    .onAppear {
      settingsViewModel.checkNotificationSettings()
    }
    .navigationTitle("Settings")
    .alert(isPresented: $settingsViewModel.notificationSettingsDisabledAlert) {
      Alert(title: Text("Vibur"), message: Text("Notifications disabled in App Settings"), primaryButton: .cancel(), secondaryButton: .default(Text("Open Settings"), action: openAppSettings))
    }
  }
  
  private func openAppSettings() {
    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
      UIApplication.shared.open(appSettings)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SettingsView()
    }
  }
}
