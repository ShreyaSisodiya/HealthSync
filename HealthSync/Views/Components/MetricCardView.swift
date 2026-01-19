//
//  MetricCardView.swift
//  HealthSync
//
//  Created by Shreya Sisodiya on 1/18/26.
//

import SwiftUI

struct MetricCardView: View {
    let metric: HealthMetric
    let goal: Double?
    
    init(metric: HealthMetric, goal: Double? = nil) {
        self.metric = metric
        self.goal = goal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: metric.type.icon)
                    .font(.title2)
                    .foregroundColor(colorForMetric)
                
                Spacer()
                
                if let goal = goal {
                    ProgressView(value: metric.value, total: goal)
                        .frame(width: 40)
                        .tint(colorForMetric)
                }
            }
            
            Text(metric.type.rawValue)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(metric.formattedValue)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Text(metric.type.unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let goal = goal {
                ProgressView(value: metric.value / goal)
                    .tint(colorForMetric)
            }
        }
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
    }
    
    private var colorForMetric: Color {
        switch metric.type {
        case .steps: return .theme.steps
        case .heartRate: return .theme.heartRate
        case .activeEnergy: return .theme.activeEnergy
        case .distance: return .theme.distance
        case .workout: return .theme.workout
        }
    }
}

#Preview {
    MetricCardView(
        metric: HealthMetric(
            type: .steps,
            value: 8543,
            date: Date()
        ),
        goal: 10000
    )
    .padding()
}
