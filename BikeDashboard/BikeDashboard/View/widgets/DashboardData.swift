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
    @State private var heartRate: Double = 0
    
    @State var trigger = false
    @State var authenticated = false
    
    let healthStore = HKHealthStore()
    
    // Create the HealthKit data types your app
    // needs to read and write.
    let allTypes: Set = [
        //HKQuantityType.workoutType(),
        //HKQuantityType(.activeEnergyBurned),
        //HKQuantityType(.distanceCycling),
        //HKQuantityType(.distanceWalkingRunning),
        //HKQuantityType(.distanceWheelchair),
        HKQuantityType(.heartRate)
    ]
    
    var body: some View {
        VStack {
            Text("Pace: \(locationManager.pace, specifier: "%.1f") min/km")
            Text("Heart Rate: \(heartRate, specifier: "%.0f")")
                .font(.title)
            
            Button(action: {
                getHeartRate()
            }) {
                Text("Get Heart Rate")
                    .font(.headline)
            }
            .disabled(!authenticated)
        }
        // If HealthKit data is available, request authorization
        // when this view appears.
        .onAppear() {
            
            // Check that Health data is available on the device.
            if HKHealthStore.isHealthDataAvailable() {
                // Modifying the trigger initiates the health data
                // access request.
                trigger.toggle()
            }
        }
        // Requests access to share and read HealthKit data types
        // when the trigger changes.
        .healthDataAccessRequest(store: healthStore,
                                 shareTypes: allTypes,
                                 readTypes: allTypes,
                                 trigger: trigger) { result in
            switch result {
                
            case .success(_):
                authenticated = true
            case .failure(let error):
                // Handle the error here.
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
    private func getHeartRate() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let date = Date()
        let predicate = HKQuery.predicateForSamples(withStart: date.addingTimeInterval(-36000), end: date, options: .strictEndDate)
        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let quantity = result.averageQuantity() else {
                return
            }
            self.heartRate = quantity.doubleValue(for: HKUnit(from: "count/min"))
        }
        healthStore.execute(query)
        }
}

#Preview {
    DashboardData()
}
