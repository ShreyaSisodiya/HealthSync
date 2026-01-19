//
//  DashboardViewModel.swift
//  HealthSync
//
//  Created by Shreya Sisodiya on 1/18/26.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var selectedDate = Date()
    @Published var dailySummary: DailyHealthSummary?
    @Published var errorMessage: String?
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    
    private let healthKitManager: HealthKitManaging
    
    enum AuthorizationStatus {
        case notDetermined
        case authorized
        case denied
    }
    
    init(healthKitManager: HealthKitManaging = HealthKitManager.shared) {
        self.healthKitManager = healthKitManager
    }
    
    func requestAuthorization() async {
        do {
            try await healthKitManager.requestAuthorization()
            authorizationStatus = .authorized
            await loadData()
        } catch {
            authorizationStatus = .denied
            errorMessage = "Unable to access Health data. Please enable in Settings."
        }
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            dailySummary = try await healthKitManager.fetchDailySummary(for: selectedDate)
        } catch {
            errorMessage = "Failed to load health data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        Task {
            await loadData()
        }
    }
}
