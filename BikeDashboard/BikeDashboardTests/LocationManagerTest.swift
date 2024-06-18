//
//  LocationManagerTest.swift
//  BikeDashboardTests
//
//  Created by Mate Granic on 18.06.2024..
//

import XCTest
@testable import BikeDashboard

final class LocationManagerTest: XCTestCase {

    func testCalculatePace() {
        let currentSpeed = 60.0
        let locMgr = LocationManager()
        
        let pace = locMgr.calculatePace(currSpeed: currentSpeed)
        
        XCTAssertEqual(pace, 1.0)
    }

}
