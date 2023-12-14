//
//  LocationManager.swift
//  BikeDashboard
//
//  Created by Mate Granic on 14.12.2023..
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var currentSpeed: Double
    var locationManager: CLLocationManager
    
    let mpsToKmh = 3.6      // transform from m/s to km/h
    
    override init() {
        locationManager = CLLocationManager()
        self.currentSpeed = 100.0
        super.init()
        //setupLocationManager()
    }
    
    // initialize location manager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    // Start monitoring the location and all the related data (like speed)
    func startLocationMonitoring() {
        setupLocationManager()
        locationManager.startUpdatingLocation()
    }
    
    // This function has to be implemented in order to comply with CLLocationManagerDelegate
    // It is executed if reading of speed from locationManager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {     // Needed for request
        print("Error: *** \(error.localizedDescription) ***")
    }
    
    // This function has to be implemented in order to comply with CLLocationManagerDelegate
    // It is executed every time new new location (speed) is red from locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
    
        if let location = locations.last {
            // set speed to 0 if negative number is detected
            let speed = ((location.speed < 0.0) ? 0.0 : location.speed)
            self.currentSpeed = speed * mpsToKmh // transform from m/s to km/h
        }
    }
}
