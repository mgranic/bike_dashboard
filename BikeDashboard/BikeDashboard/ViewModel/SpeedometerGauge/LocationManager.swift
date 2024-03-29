//
//  LocationManager.swift
//  BikeDashboard
//
//  Created by Mate Granic on 14.12.2023..
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var currentSpeed: Double
    @Published var totalDistance: Double
    @Published var tripDistance: Double
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var locationManager: CLLocationManager
    
    private var lastLocation: CLLocation?

    
    private let mpsToKmh = 3.6      // transform from m/s to km/h
    private let mToKm = 1000.0      // meters to kilometers
    
    override init() {
        locationManager = CLLocationManager()
        self.currentSpeed = 0.0
        self.totalDistance = 0.0
        self.tripDistance = 0.0
        super.init()
        setupLocationManager()
    }
    
    // initialize location manager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    // Start monitoring the location and all the related data (like speed)
    func startLocationMonitoring() {
        //setupLocationManager()
        locationManager.startUpdatingLocation()
    }
    
    // This function has to be implemented in order to comply with CLLocationManagerDelegate
    // It is executed if reading of speed from locationManager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {     // Needed for request
        Alert(title: Text("Error: *** \(error.localizedDescription) ***"))
    }
    
    // This function has to be implemented in order to comply with CLLocationManagerDelegate
    // It is executed every time new new location (speed) is red from locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
    
        if let location = locations.last {
            // set speed to 0 if negative number is detected
            let speed = ((location.speed < 0.0) ? 0.0 : location.speed)
            self.currentSpeed = speed * mpsToKmh // transform from m/s to km/h
            
            // if location is valid, calculate distance traveled
            if (self.lastLocation == nil) {
                self.lastLocation = location
            } else {
                let distanceFromLastLocation = ((location.distance(from: lastLocation!)) / mToKm)
                self.totalDistance += distanceFromLastLocation
                self.tripDistance += distanceFromLastLocation
                self.lastLocation = location
            }
            
            // update map
            mapRegion.center.latitude = location.coordinate.latitude
            mapRegion.center.longitude = location.coordinate.longitude
        }
    }
    
    // store total distance in UserDefaults
    func saveTotalDistance() {
        let defaults = UserDefaults.standard
        defaults.setValue(self.totalDistance, forKey: "odometer_value")
    }
    
    // read total distance from user defaults
    func loadTotalDistance() {
        let storedDistance = UserDefaults.standard.double(forKey: "odometer_value")
        
        // if total distance is greater than the one stored in the UserDefaults, use total distance
        self.totalDistance = (self.totalDistance > storedDistance) ? self.totalDistance : storedDistance
    }
    
    // reset current trip
    func resetTrip() {
        self.tripDistance = 0.0
    }
}
