//
//  ContentView.swift
//  BikeDashboard
//
//  Created by Mate Granic on 04.12.2023..
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    //@State var currentSpeed: Double = 60.0
    @State var totalDistance: Double = 0.0
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    VStack {
                        Spacer(minLength: 200)
                        SpeedometerGauge(isMoovable: false, startAngleDegrees: -180, endAngleDegrees: 0, speed: locationManager.currentSpeed)
                            .stroke(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, lineWidth: 30)
                    }
                    VStack {
                        Spacer(minLength: 200)
                        SpeedometerGauge(isMoovable: true, startAngleDegrees: 0, endAngleDegrees: locationManager.currentSpeed, speed: locationManager.currentSpeed)
                            .rotation(Angle(degrees: 180))
                            .stroke(Color.red, lineWidth: 20)
                            .onAppear {
                                locationManager.startLocationMonitoring()
                            }
                            //.animation(.linear, value: 0.1)
                        
                    }
                    VStack {
                        Text("\(locationManager.currentSpeed, specifier: "%.1f") km/h")
                            .font(.largeTitle)
                        HStack {
                            Text("Total distance:")
                            Text("\(totalDistance, specifier: "%.2f")")
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
