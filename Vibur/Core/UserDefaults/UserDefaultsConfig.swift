//
//  UserDefaultsConfig.swift
//  Sharentic
//
//  Created by Kristaps Grinbergs on 28/10/2020.
//

import Foundation

struct UserDefaultsConfig {
  @UserDefault("pushNotificationID", defaultValue: "")
  static var pushNotificationID: String
  
  @UserDefault("pushNotificationTime", defaultValue: Date())
  static var pushNotificationTime: Date
}
