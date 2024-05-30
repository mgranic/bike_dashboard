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
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Pace: \(locationManager.pace, specifier: "%.1f") min/km")
            Text("Heart Rate: \(heartRate, specifier: "%.0f")")
                .font(.title)
                .onReceive(timer) { input in
                    guard authenticated else {return}
                    Task {
                        await getHeartRate()
                    }
                }
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
    private func getHeartRate() async {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Create the descriptor.
        let descriptor = HKSampleQueryDescriptor(
            predicates:[.quantitySample(type: heartRateType)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 1)


        // Launch the query and wait for the results.
        // The system automatically sets results to [HKQuantitySample].
        let results = try! await descriptor.result(for: healthStore)
        
        heartRate = results.first?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? -1.5
        
    }
}

#Preview {
    DashboardData()
}
