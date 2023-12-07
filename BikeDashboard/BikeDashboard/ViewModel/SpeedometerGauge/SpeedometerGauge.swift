//
//  SpeedometerGauge.swift
//  BikeDashboard
//
//  Created by Mate Granic on 05.12.2023..
//

import Foundation
import SwiftUI
import Dispatch
//import CoreMotion

final class SpeedometerGauge: Shape {
    @Binding var currentSpeed: Double
    
    var animatableData: Double {
        get {
            currentSpeed
        }
        set {
            currentSpeed = newValue
        }
    }
    
    //var extendedRange: Bool = false
    var startAngleDegrees: Double = 0.0
    var endAngleDegrees: Double = 180.0
    
    //private let locationManager = CLLocationManager()
    
    init(isMoovable: Bool, startAngleDegrees: Double, endAngleDegrees: Double, speed: Binding<Double>) {
        //self.extendedRange = extendedRange
        self.startAngleDegrees = startAngleDegrees
        self.endAngleDegrees = endAngleDegrees
        self._currentSpeed = speed
        if (isMoovable == true) {
            monitorSpeed()
           // let locationManager = CLLocationManager()
           // // Get the current location
           // if let currentLocation = locationManager.location {
           // // Get the speed in meters per second
           // let speed = currentLocation.speed
           // // Convert the speed to kilometers per hour
           // self.currentSpeed = speed * 3.6
           // }
        }
    }
    
    //private let speedometerRange50: Int = 50
    //private let speedometerRange200: Int = 200
    //
    //private var degreesPerKmh: Double {
    //    180 / Double((extendedRange ? speedometerRange200 : speedometerRange50))
    //}
    
    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngleDegrees), endAngle: Angle(degrees: endAngleDegrees), clockwise: false)

        }
    }
    
    func monitorSpeed() {
        let timerQUeue = DispatchQueue(label: "Update sppedometer", qos: .userInteractive)
        
        timerQUeue.sync {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: false)
        }
    }
    
    @objc func updateSpeed() {
        currentSpeed += 1
        if (currentSpeed > 180) {
            currentSpeed = 0
        }
    }
    
    
}
