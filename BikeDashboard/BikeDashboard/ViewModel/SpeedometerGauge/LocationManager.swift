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
import UserNotifications

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var currentSpeed: Double
    @Published var totalDistance: Double
    @Published var tripDistance: Double
    @Published var pace: Double
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var locationManager: CLLocationManager
    
    private var lastLocation: CLLocation?
    private var lastNotificationDIstance = 0.0
    
    private let mpsToKmh = 3.6      // transform from m/s to km/h
    private let mToKm = 1000.0      // meters to kilometers
    private let distanceNotificationStep = 2.0 // distance in km that should be alarmed to user
    
    
    override init() {
        locationManager = CLLocationManager()
        self.currentSpeed = 0.0
        self.totalDistance = 0.0
        self.tripDistance = 0.0
        self.pace = 0.0
        super.init()
        setupLocationManager()
    }
    
    // Start monitoring the location and all the related data (like speed)
    func startLocationMonitoring() {
        locationManager.startUpdatingLocation()
    }
    
    // This function has to be implemented in order to comply with CLLocationManagerDelegate
    // It is executed if reading of speed from locationManager fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {     // Needed for request
        //Alert(title: Text("Error: *** \(error.localizedDescription) ***"))
    }
    
    // This function has to be implemented in order to comply with CLLocationManagerDelegate
    // It is executed every time new new location (speed) is red from locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
    
        if let location = locations.last {
            self.currentSpeed = calculateCurrentSpeed(location: location)
            
            self.pace = calculatePace(currSpeed: currentSpeed)
            
            // if this is first location obtained (no last location
            if (lastLocation == nil) {
                lastLocation = location
            } else { // if location is valid, calculate distance traveled
                let distanceFromLastLocation = ((location.distance(from: lastLocation!)) / mToKm)
                totalDistance += distanceFromLastLocation
                tripDistance += distanceFromLastLocation
                lastNotificationDIstance += distanceFromLastLocation
                lastLocation = location
                
                // show notification for every 5 kilometers in current trip
                if (lastNotificationDIstance >= distanceNotificationStep) {
                    lastNotificationDIstance = 0
                    showNotification(distanceTraveled: tripDistance)
                }
                
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
    
    /**************************************************************PRIVATE FUNCTIONS************************************************************/
    // initialize location manager
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    // calculate current pace
    func calculatePace(currSpeed: Double) -> Double { // made public for unit testing
        // if current speed is zero or less, avoid division with that number (pace = 0.0)
        if (currSpeed <= 0.0) {
            return 0.0
        } else {
            return (60 / currSpeed) // pace is minutes/km (60 minutes in an hour)
        }
    }
    
    // calculate current speed in km/h
    private func calculateCurrentSpeed(location: CLLocation) -> Double {
        // set speed to 0 if negative number is detected
        let speed = ((location.speed < 0.0) ? 0.0 : location.speed)
        return (speed * mpsToKmh) // transform from m/s to km/h
    }
    
    // display notification to the user showing current trip distance
    private func showNotification(distanceTraveled: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Distance milestone"
        content.subtitle = "Current trip distance: \(distanceTraveled)"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
