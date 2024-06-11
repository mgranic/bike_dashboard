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
        NavigationStack {
            VStack {
                VStack {
                    TabView {
                        SpeedometerDashboard()
                            .environmentObject(locationManager)
                        DashboardData()
                            .environmentObject(locationManager)
                    }
                    .tabViewStyle(.page)
                    
                    //Map(coordinateRegion: $locationManager.mapRegion, showsUserLocation: true,
                    //    userTrackingMode: .constant(.follow))
                    Map(position: .constant(MapCameraPosition.region(locationManager.mapRegion)), bounds: nil, interactionModes: .all, scope: nil) {
                        UserAnnotation()
                    }
                }
                .onAppear {
                    locationManager.startLocationMonitoring()
                    UIApplication.shared.isIdleTimerDisabled = true
                }
            }
            .toolbar {
                Menu {
                    NavigationLink(destination: SettingsScreen()) {
                        Text("Settings")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
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
        }
        .padding()
    }
}

#Preview {
    MainScreen()
}
