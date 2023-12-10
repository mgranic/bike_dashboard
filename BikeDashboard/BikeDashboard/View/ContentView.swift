//
//  ContentView.swift
//  BikeDashboard
//
//  Created by Mate Granic on 04.12.2023..
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State var currentSpeed = 60.0
    //let locationManager = CLLocationManager()
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    VStack {
                        Spacer(minLength: 200)
                        SpeedometerGauge(isMoovable: false, startAngleDegrees: -180, endAngleDegrees: 0, speed: $currentSpeed)
                            .stroke(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, lineWidth: 30)
                    }
                    VStack {
                        Spacer(minLength: 200)
                        SpeedometerGauge(isMoovable: true, startAngleDegrees: 0, endAngleDegrees: currentSpeed, speed: $currentSpeed)
                            .rotation(Angle(degrees: 180))
                            .stroke(Color.red, lineWidth: 20)
                            //.animation(.linear, value: 0.1)
                        
                    }
                    VStack {
                        Text("\(currentSpeed, specifier: "%.f") km/h")
                            .font(.largeTitle)
                        //Button("Request Always Location Permission") {
                        //
                        //    locationManager.requestAlwaysAuthorization()
                        //}
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
