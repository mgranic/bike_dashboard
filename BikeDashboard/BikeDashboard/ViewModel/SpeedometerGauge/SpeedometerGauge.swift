//
//  SpeedometerGauge.swift
//  BikeDashboard
//
//  Created by Mate Granic on 05.12.2023..
//

import Foundation
import SwiftUI
import CoreLocation

final class SpeedometerGauge: NSObject, Shape, CLLocationManagerDelegate {
    var currentSpeed: Double
    var locationManager = CLLocationManager()
    //var locMan: LocationManager
    
    let timerPeriod = 10.0
    let mpsToKmh = 3.6      // transform from m/s to km/h
    
    var startAngleDegrees: Double = 0.0
    var endAngleDegrees: Double = 180.0
    
    //private let locationManager = CLLocationManager()
    
    init(isMoovable: Bool, startAngleDegrees: Double, endAngleDegrees: Double, speed: Double) {
        self.startAngleDegrees = startAngleDegrees
        self.endAngleDegrees = endAngleDegrees
        self.currentSpeed = speed
        //self.locMan = LocationManager(currSpeed: speed)
        super.init()
        if (isMoovable == true) {
            //self.locMan.startLocationMonitoring()
            //setupLocationManager()
        }
    }
    
    //// initialize location manager
    //func setupLocationManager() {
    //    locationManager.delegate = self
    //    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //    locationManager.requestAlwaysAuthorization()
    //    locationManager.startUpdatingLocation()
    //}
    //
    //// This function has to be implemented in order to comply with CLLocationManagerDelegate
    //// It is executed if reading of speed from locationManager fails
    //func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {     // Needed for request
    //    print("Error: *** \(error.localizedDescription) ***")
    //}
    //
    //// This function has to be implemented in order to comply with CLLocationManagerDelegate
    //// It is executed every time new new location (speed) is red from locationManager
    //func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
    //
    //    if let location = locations.last {
    //        // set speed to 0 if negative number is detected
    //        let speed = ((location.speed < 0.0) ? 0.0 : location.speed)
    //        self.currentSpeed = speed * mpsToKmh // transform from m/s to km/h
    //    }
    //}
    
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
}
