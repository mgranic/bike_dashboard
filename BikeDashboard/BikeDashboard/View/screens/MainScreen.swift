//
//  ContentView.swift
//  BikeDashboard
//
//  Created by Mate Granic on 04.12.2023..
//

import SwiftUI
import MapKit

struct MainScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack {
            VStack {
                TabView {
                    SpeedometerDashboard()
                        .environmentObject(locationManager)
                    DashboardDataScreen()
                        .environmentObject(locationManager)
                }
                .tabViewStyle(.page)
                
            Map(coordinateRegion: $locationManager.mapRegion, showsUserLocation: true,
                userTrackingMode: .constant(.follow))
            }
            .onAppear {
                locationManager.startLocationMonitoring()
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
        .onChange(of: scenePhase, {
            if (scenePhase == .background) {
                // store total distance in UserDefauls
                locationManager.saveTotalDistance()
            } else if (scenePhase == .active) {
                // read data distance from userDefaults
                locationManager.loadTotalDistance()
            }
        })
        .padding()
    }
}

#Preview {
    MainScreen()
}
