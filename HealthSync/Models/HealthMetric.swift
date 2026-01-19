//
//  HealthMetric.swift
//  HealthSync
//
//  Created by Shreya Sisodiya on 1/18/26.
//

import Foundation

enum HealthMetricType: String, Codable, CaseIterable {
    case steps = "Steps"
    case heartRate = "Heart Rate"
    case activeEnergy = "Active Energy"
    case distance = "Distance"
    case workout = "Workout"
    
    var unit: String {
        switch self {
        case .steps: return "steps"
        case .heartRate: return "bpm"
        case .activeEnergy: return "kcal"
        case .distance: return "km"
        case .workout: return "min"
        }
    }
    
    var icon: String {
        switch self {
        case .steps: return "figure.walk"
        case .heartRate: return "heart.fill"
        case .activeEnergy: return "flame.fill"
        case .distance: return "map.fill"
        case .workout: return "figure.run"
        }
    }
}

struct HealthMetric: Identifiable {
    let id = UUID()
    let type: HealthMetricType
    let value: Double
    let date: Date
    
    var formattedValue: String {
        switch type {
        case .steps, .distance:
            return String(format: "%.0f", value)
        case .heartRate, .activeEnergy:
            return String(format: "%.1f", value)
        case .workout:
            return String(format: "%.0f", value)
        }
    }
}
