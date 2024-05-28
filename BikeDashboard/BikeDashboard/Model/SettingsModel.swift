//
//  SettingsModel.swift
//  BikeDashboard
//
//  Created by Mate Granic on 28.05.2024..
//

import Foundation
import SwiftData

@Model
class SettingsModel {
    var speedometerRange: Double
    
    init(speedometerRange: Double) {
        self.speedometerRange = speedometerRange
    }
}
