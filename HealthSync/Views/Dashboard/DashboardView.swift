//
//  DashboardView.swift
//  HealthSync
//
//  Created by Shreya Sisodiya on 1/18/26.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                if viewModel.authorizationStatus == .notDetermined {
                    authorizationView
                } else if viewModel.authorizationStatus == .denied {
                    deniedView
                } else {
                    contentView
                }
            }
            .navigationTitle("HealthSync")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            if viewModel.authorizationStatus == .notDetermined {
                await viewModel.requestAuthorization()
            }
        }
    }
    
    // MARK: - Authorization View
    
    private var authorizationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 80))
                .foregroundColor(.theme.accent)
            
            Text("Welcome to HealthSync")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Track your health data with privacy-first insights")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                Task {
                    await viewModel.requestAuthorization()
                }
            } label: {
                Text("Connect to Health")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.theme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
    
    // MARK: - Denied View
    
    private var deniedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Health Access Denied")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Please enable Health access in Settings to use HealthSync")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.theme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Content View
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Date Picker
                DatePicker(
                    "Select Date",
                    selection: Binding(
                        get: { viewModel.selectedDate },
                        set: { viewModel.selectDate($0) }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(Color.theme.cardBackground)
                .cornerRadius(16)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if let summary = viewModel.dailySummary {
                    summaryCards(for: summary)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.loadData()
        }
    }
    
    @ViewBuilder
    private func summaryCards(for summary: DailyHealthSummary) -> some View {
        VStack(spacing: 16) {
            MetricCardView(
                metric: HealthMetric(type: .steps, value: summary.steps, date: summary.date),
                goal: 10000
            )
            
            HStack(spacing: 16) {
                MetricCardView(
                    metric: HealthMetric(type: .distance, value: summary.distance, date: summary.date)
                )
                
                MetricCardView(
                    metric: HealthMetric(type: .activeEnergy, value: summary.activeEnergy, date: summary.date)
                )
            }
            
            if let heartRate = summary.heartRateAvg {
                MetricCardView(
                    metric: HealthMetric(type: .heartRate, value: heartRate, date: summary.date)
                )
            }
            
            if summary.workoutMinutes > 0 {
                MetricCardView(
                    metric: HealthMetric(type: .workout, value: summary.workoutMinutes, date: summary.date)
                )
            }
        }
    }
}

#Preview {
    DashboardView()
}
