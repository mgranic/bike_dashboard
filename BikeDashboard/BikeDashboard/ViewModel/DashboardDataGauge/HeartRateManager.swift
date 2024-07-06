//
//  HeartRateManager.swift
//  BikeDashboard
//
//  Created by Mate Granic on 06.07.2024..
//

import Foundation
import HealthKitUI

class HeartRateManager: ObservableObject {
    @Published var heartRate: Double = 0
    
    let healthStore = HKHealthStore()
    
    var timer: Timer?
    
    // Create the HealthKit data types your app
    // needs to read and write.
    let allTypes: Set = [
        HKQuantityType(.heartRate)
    ]
    
    // start 10 second periodic timer
    func startHeartRateMeasurement() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            Task {
                await self.getHeartRate()
            }
        }
    }
    
    // get heart rate
    func getHeartRate() async {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Create the descriptor.
        let descriptor = HKSampleQueryDescriptor(
            predicates:[.quantitySample(type: heartRateType)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 1)


        do {
            // Launch the query and wait for the results.
            // The system automatically sets results to [HKQuantitySample].
            let results = try await descriptor.result(for: healthStore)
            
            // Update the published property on the main thread
            DispatchQueue.main.async {
                self.heartRate = results.first?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? -1.5
            }
        } catch {
            DispatchQueue.main.async {
                self.heartRate =  -5.0
            }
        }
        
    }
    
    // stop timer for getting heart rate
    func stopTimer() {
        timer?.invalidate();
    }
}
