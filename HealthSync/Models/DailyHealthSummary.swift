//
//  DailyHealthSummary.swift
//  HealthSync
//
//  Created by Shreya Sisodiya on 1/18/26.
//

import Foundation

struct DailyHealthSummary: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Double
    let heartRateAvg: Double?
    let activeEnergy: Double
    let distance: Double
    let workoutMinutes: Double
    
    var completionPercentage: Double {
        // Simple calculation: steps goal is 10,000
        return min(steps / 10_000 * 100, 100)
    }
    
    var stepsGoalMet: Bool {
        steps >= 10_000
    }
}
