//
//  Color+Theme.swift
//  HealthSync
//
//  Created by Shreya Sisodiya on 1/18/26.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color.accentColor
    let background = Color(UIColor.systemBackground)
    let cardBackground = Color(UIColor.secondarySystemBackground)
    let primaryText = Color.primary
    let secondaryText = Color.secondary
    
    // Health metric colors
    let steps = Color.blue
    let heartRate = Color.red
    let activeEnergy = Color.orange
    let distance = Color.green
    let workout = Color.purple
}
