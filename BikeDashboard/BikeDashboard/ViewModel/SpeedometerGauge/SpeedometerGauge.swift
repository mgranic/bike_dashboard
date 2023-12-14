//
//  SpeedometerGauge.swift
//  BikeDashboard
//
//  Created by Mate Granic on 05.12.2023..
//

import Foundation
import SwiftUI
import Dispatch
import CoreLocation

final class SpeedometerGauge: NSObject, Shape, CLLocationManagerDelegate {
    @Binding var currentSpeed: Double
    var locationManager = CLLocationManager()
    static var monitorTimer: Timer?
    var timerQueue: DispatchQueue?
    
    let timerPeriod = 10.0
    let mpsToKmh = 3.6      // transform from m/s to km/h
    
    //var extendedRange: Bool = false
    var startAngleDegrees: Double = 0.0
    var endAngleDegrees: Double = 180.0
    
    //private let locationManager = CLLocationManager()
    
    init(isMoovable: Bool, startAngleDegrees: Double, endAngleDegrees: Double, speed: Binding<Double>) {
        self.startAngleDegrees = startAngleDegrees
        self.endAngleDegrees = endAngleDegrees
        self._currentSpeed = speed
        super.init()
        if (isMoovable == true) {
            setupLocationManager()
            //monitorSpeed()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // This function has to be implemented in order to comply with CLLocationManagerDelegate
    // It is executed if reading of speed from locationManager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {     // Needed for request
        print("Error: *** \(error.localizedDescription) ***")
    }
    
    // This function has to be implemented in order to comply with CLLocationManagerDelegate
    // It is executed every time new new speed is red from locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
    
        if let location = locations.last {
            if (location.speed <= 0.0) {
                self.currentSpeed = abs(0.0 * mpsToKmh) // transform from m/s to km/h
            } else {
                self.currentSpeed = abs(location.speed * mpsToKmh) // transform from m/s to km/h
            }
            print("**** speed = \(location.speed)")
            print("**** currentSpeed = \(currentSpeed)")
        }
    }
    
    // draw arc. This function has to be implemented in order to comply with Shape protocol
    // It is executed as soon as Shape object is created
    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngleDegrees), endAngle: Angle(degrees: endAngleDegrees), clockwise: false)

        }
    }
    
    // Start the timer that will periodically get speed from the locationManager
    func monitorSpeed() {
        if (timerQueue == nil) {
            timerQueue = DispatchQueue(label: "Update sppedometer", qos: .userInteractive)
        }
        
        timerQueue!.sync {
            if (SpeedometerGauge.monitorTimer == nil) {
                SpeedometerGauge.monitorTimer = Timer.scheduledTimer(timeInterval: timerPeriod, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
            }
            
        }
    }
    
    // Function executed periodically to update current speed
    @objc func updateSpeed() {
        // Start monitoring speed
        if let currentLocation = self.locationManager.location {
            self.currentSpeed = abs(Double(currentLocation.speed) * mpsToKmh)
        } else {
            self.currentSpeed = 0.0
        }
    }
}
