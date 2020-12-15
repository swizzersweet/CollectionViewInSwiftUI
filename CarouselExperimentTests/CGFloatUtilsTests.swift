//
//  CGFloatUtilsTests.swift
//  CarouselExperimentTests
//
//  Created by Jonathan Menard on 2020-11-24.
//  Copyright © 2020 Jonathan Menard. All rights reserved.
//

import Foundation
import XCTest

@testable import CarouselExperiment

extension FloatingPoint {
    func mapToRange(source: ClosedRange<Self>, target: ClosedRange<Self>, isClamped: Bool = false) -> Self {
        // split up into parts for compiler build time optimization
        let valueWithAdjustedFloor = self - source.lowerBound
        let sourceRangeExtent = (source.upperBound - source.lowerBound)
        let mappedToRange = target.lowerBound + (target.upperBound - target.lowerBound) * valueWithAdjustedFloor / sourceRangeExtent
        return isClamped ? mappedToRange.clamp(minimum: target.lowerBound, maximum: target.upperBound) : mappedToRange
    }

    // clamps values between a min and a max
    func clamp(minimum: Self, maximum: Self) -> Self {
        min(max(self, minimum), maximum)
    }
}

final class CGFloatUtilsTests: XCTestCase {

    func testClampBelowRange() {
        let value = CGFloat(-5.0).clamp(to: 0.0...1.0)
        XCTAssertEqual(value, 0.0)
    }

    func testClampInRange() {
        let value = CGFloat(3.0).clamp(to: 0.0...10.0)
        XCTAssertEqual(value, 3.0)
    }

    func testClampAboveRange() {
        let value = CGFloat(15.0).clamp(to: 0.0...10.0)
        XCTAssertEqual(value, 10.0)
    }

    func testMapToBelowRange() {
        let value = CGFloat(-10.0).map(from: 0.0...10.0, to: 100.0...200.0)
        XCTAssertEqual(value, 0.0)
    }

    func testMapToBelowRangeClamped() {
        let value = CGFloat(-10.0).map(from: 0.0...10.0, to: 100.0...200.0, isClamped: true)
        XCTAssertEqual(value, 100.0)
    }

    func testMapToInRange() {
        let value = CGFloat(5.0).map(from: 0.0...10.0, to: 100.0...200.0)
        XCTAssertEqual(value, 150.0)
    }

    func testMapToAboveRange() {
        let value = CGFloat(20.0).map(from: 0.0...10.0, to: 100.0...200.0)
        XCTAssertEqual(value, 300.0)
    }

    func testMapToAboveRangeClamped() {
        let value = CGFloat(20.0).map(from: 0.0...10.0, to: 100.0...200.0, isClamped: true)
        XCTAssertEqual(value, 200.0)
    }
}
