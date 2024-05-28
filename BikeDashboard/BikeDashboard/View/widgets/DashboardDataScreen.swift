//
//  DashboardDataScreen.swift
//  BikeDashboard
//
//  Created by Mate Granic on 28.05.2024..
//

import SwiftUI

struct DashboardDataScreen: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        Text("Pace: \(locationManager.pace, specifier: "%.1f") min/km")
    }
}

#Preview {
    DashboardDataScreen()
}
