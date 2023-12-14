//
//  ContentView.swift
//  BikeDashboard
//
//  Created by Mate Granic on 04.12.2023..
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    VStack {
                        Spacer(minLength: 200)
                        SpeedometerGauge(startAngleDegrees: -180, endAngleDegrees: 0)
                            .stroke(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, lineWidth: 30)
                    }
                    VStack {
                        Spacer(minLength: 200)
                        SpeedometerGauge(startAngleDegrees: 0, endAngleDegrees: locationManager.currentSpeed)
                            .rotation(Angle(degrees: 180))
                            .stroke(Color.red, lineWidth: 20)
                        
                    }
                    VStack {
                        Text("\(locationManager.currentSpeed, specifier: "%.1f") km/h")
                            .font(.largeTitle)
                        HStack {
                            Text("Total distance:")
                            Text("\(locationManager.totalDistance, specifier: "%.2f")")
                        }
                    }
                }
            }
            .onAppear {
                locationManager.startLocationMonitoring()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
