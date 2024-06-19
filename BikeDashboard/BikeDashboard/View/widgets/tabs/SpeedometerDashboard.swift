//
//  SpeedometerDashboard.swift
//  BikeDashboard
//
//  Created by Mate Granic on 28.05.2024..
//

import SwiftUI

struct SpeedometerDashboard: View {
    @EnvironmentObject var locationManager: LocationManager
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: UIScreen.main.bounds.height * 0.05)
                SpeedometerGauge(startAngleDegrees: -180, endAngleDegrees: 0)
                    .stroke(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, lineWidth: 30)
            }
            VStack {
                Spacer(minLength: UIScreen.main.bounds.height * 0.05)
                SpeedometerGauge(startAngleDegrees: 0, endAngleDegrees: locationManager.currentSpeed)
                    .rotation(Angle(degrees: 180))
                    .stroke(Color.red, lineWidth: 20)
            }
            VStack {
                Text("\(locationManager.currentSpeed, specifier: "%.1f") km/h")
                    .font(.largeTitle)
                HStack {
                    Text("Odometer:")
                    Text("\(locationManager.totalDistance, specifier: "%.2f") km")
                }
                HStack {
                    Text("Trip")
                    Text("\(locationManager.tripDistance, specifier: "%.2f") km")
                }
                Button("Reset trip") {
                    locationManager.resetTrip()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    SpeedometerDashboard()
}
