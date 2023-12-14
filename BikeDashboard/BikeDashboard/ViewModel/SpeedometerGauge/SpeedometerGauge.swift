//
//  SpeedometerGauge.swift
//  BikeDashboard
//
//  Created by Mate Granic on 05.12.2023..
//

import Foundation
import SwiftUI
import CoreLocation

final class SpeedometerGauge: NSObject, Shape {

    var startAngleDegrees: Double = 0.0
    var endAngleDegrees: Double = 180.0
    
    init(startAngleDegrees: Double, endAngleDegrees: Double) {
        self.startAngleDegrees = startAngleDegrees
        self.endAngleDegrees = endAngleDegrees
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
}
