//
//  ContentView.swift
//  BikeDashboard
//
//  Created by Mate Granic on 04.12.2023..
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack {
            VStack {
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
                Map(coordinateRegion: $locationManager.mapRegion, showsUserLocation: true,
                    userTrackingMode: .constant(.follow))
            }
            .onAppear {
                locationManager.startLocationMonitoring()
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
        .onChange(of: scenePhase, {
            if (scenePhase == .background) {
                // store total distance in UserDefauls
                locationManager.saveTotalDistance()
            } else if (scenePhase == .active) {
                // read data distance from userDefaults
                locationManager.loadTotalDistance()
            }
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
