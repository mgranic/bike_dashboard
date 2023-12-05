//
//  ContentView.swift
//  BikeDashboard
//
//  Created by Mate Granic on 04.12.2023..
//fdvf

import SwiftUI

struct ContentView: View {
    @State var currentSpeed = 10.0
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    SpeedometerGauge(extendedRange: false, startAngleDegrees: -180, endAngleDegrees: 0, speed: $currentSpeed)
                        .stroke(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, lineWidth: 14)
                    SpeedometerGauge(extendedRange: true, startAngleDegrees: 0, endAngleDegrees: currentSpeed, speed: $currentSpeed)
                        .rotation(Angle(degrees: 180))
                        .stroke(Color.red, lineWidth: 14)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
