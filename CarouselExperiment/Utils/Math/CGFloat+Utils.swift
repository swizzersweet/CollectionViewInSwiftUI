//
//  CGFloat+Utils.swift
//  CarouselExperiment
//
//  Created by Jonathan Menard on 2020-11-24.
//  Copyright © 2020 Jonathan Menard. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
    // Convert value in a range, to another value in a different range
    // given a value of 5.0 in a range of 0.0 to 10.0, converting to a range of 100.0 to 200.0, the end result is 150.0
    // returned values are clamped between the min and max
    func map(from source: ClosedRange<CGFloat>, to target: ClosedRange<CGFloat>, isClamped: Bool = false) -> CGFloat {
        // split up into parts for compiler build time optimization
        let valueWithAdjustedFloor = self - source.lowerBound
        let sourceRangeExtent = (source.upperBound - source.lowerBound)
        let mappedToRange = target.lowerBound + (target.upperBound - target.lowerBound) * valueWithAdjustedFloor / sourceRangeExtent
        return isClamped ? mappedToRange.clamp(to: target) : mappedToRange
    }

    // clamps values in a closed range
    func clamp(to range: ClosedRange<CGFloat>) -> CGFloat {
        .minimum(.maximum(self, range.lowerBound), range.upperBound)
    }
}

