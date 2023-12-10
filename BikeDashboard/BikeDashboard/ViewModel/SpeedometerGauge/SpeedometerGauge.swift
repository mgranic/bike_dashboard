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
            monitorSpeed()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //// Check if the app has already been authorized
        //if CLLocationManager.locationServicesEnabled() {
        //    locationManager.requestAlwaysAuthorization()
        //    // You can also use `requestAlwaysAuthorization` if needed.
        //} else {
        //    // Handle the case where location services are not enabled on the device.
        //    print("Location services are not enabled.")
        //}
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {     // Needed for request
        print("Error: *** \(error.localizedDescription) ***")
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation], didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways {
            // Start updating the user's location
            locationManager.startUpdatingLocation()
        } else {
            // Display an error message
        }
        
        if let location = locations.last {
            currentSpeed = (location.speed * 3.6) // transform from m/s to km/h
        }
        
        //switch status {
        //    case .authorizedAlways:
        //    if let location = locations.last {
        //        currentSpeed = (location.speed * 3.6) // transform from m/s to km/h
        //    }
        //        break
        //    case .denied:
        //        print("Location access denied")
        //        break
        //    case .notDetermined:
        //        manager.requestAlwaysAuthorization()
        //        break
        //    case .restricted:
        //        print("Location access restricted")
        //        break
        //    default:
        //        print("Unrecognized value")
        //    }
    }
    
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
            if (SpeedometerGauge.monitorTimer == nil) {
                SpeedometerGauge.monitorTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
            }
            
        }
    }
    
    @objc func updateSpeed() {
            //currentSpeed += 1
            //if (currentSpeed > 180) {
            //    currentSpeed = 0
            //}
        
        print("locationManager.authorizationStatus = \(locationManager.authorizationStatus)")
       if locationManager.authorizationStatus == .authorizedAlways {
                // Start monitoring speed
           if let currentLocation = self.locationManager.location {
               self.currentSpeed = Double(currentLocation.speed) * 3.6
           } else {
               self.currentSpeed = 0.0
           }
        } else {
            // Request authorization from the user
            self.locationManager.requestAlwaysAuthorization()
            //self.locationManager.requestWhenInUseAuthorization()
        }
        
    }
}
