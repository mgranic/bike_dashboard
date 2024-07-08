//
//  DashboardDataScreen.swift
//  BikeDashboard
//
//  Created by Mate Granic on 28.05.2024..
//

import SwiftUI
import HealthKitUI


struct DashboardData: View {
    @EnvironmentObject var locationManager: LocationManager
    
    
    @State var trigger = false
    @State var authenticated = false
    
    @StateObject var hrManager = HeartRateManager()
    
    var body: some View {
        VStack {
            Text("Pace: \(locationManager.pace, specifier: "%.1f") min/km")
                .font(.title)
            Text("Heart Rate: \(hrManager.heartRate, specifier: "%.0f")")
                .font(.title)
            Text("Heartbeat timestamp: \(hrManager.heartbeatTime)")
        }
        // If HealthKit data is available, request authorization
        // when this view appears.
        .onAppear() {
            //startTimer()
            // Check that Health data is available on the device.
            if HKHealthStore.isHealthDataAvailable() {
                // Modifying the trigger initiates the health data
                // access request.
                trigger.toggle()
            }
            //hrManager.startHeartRateMeasurement()
            hrManager.startHeartRateMeasurement()
            Task {
                //await getHeartRate()
                await hrManager.getHeartRate()
            }
        }
        .onDisappear() {
            hrManager.stopTimer()
        }
        // Requests access to share and read HealthKit data types
        // when the trigger changes.
        .healthDataAccessRequest(store: hrManager.healthStore,
                                 shareTypes: hrManager.allTypes,
                                 readTypes: hrManager.allTypes,
                                 trigger: trigger) { result in
            switch result {
                
            case .success(_):
                authenticated = true
                hrManager.startHeartRateMeasurement()
                Task {
                    //await getHeartRate()
                    await hrManager.getHeartRate()
                }
            case .failure(let error):
                // Handle the error here.
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
}

#Preview {
    DashboardData()
}
