//
//  SplitViewSettingsApp.swift
//  SplitViewSettings
//
//  Created by Jacek Kosinski U on 10/03/2024.
// based on article:
// //https://medium.com/@gerdcastan/write-two-column-settings-in-swiftui-that-look-and-feel-like-apples-settings-app-c2a27417f3d7

import SwiftUI

@main
struct SplitViewSettingsApp: App {
    var body: some Scene {
        WindowGroup {
            SettingsSplitView()
        }
    }
}
