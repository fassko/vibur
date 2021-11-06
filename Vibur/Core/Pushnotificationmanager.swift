//
//  Pushnotificationmanager.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import Foundation
import UIKit

class Pushnotificationmanager: NSObject {
  static func checkPushNotificationStatus(_ callback: (() -> Void)? = nil) {
    UNUserNotificationCenter.current()
      .getNotificationSettings { settings in
        switch settings.authorizationStatus {
        case .notDetermined:
          Self.askPushNotificationAccess()
        case .denied:
          print("denied")
        case .authorized, .provisional:
          callback?()
        default:
          print("unknwon")
        }
      }
  }
  
  private static func askPushNotificationAccess() {
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current()
      .requestAuthorization(options: authOptions) { granted, error in
      
      guard granted else {
        print("Can't register for push notifications \(String(describing: error))")
        return
      }
      
      Self.getNotificationSettings()
    }
  }
  
  private static func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      
      print("Notification settings: \(settings)")
      
      guard settings.authorizationStatus == .authorized else {
        return
      }
      
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
}
