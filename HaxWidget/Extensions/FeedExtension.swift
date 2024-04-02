//
//  FeedExtension.swift
//  HaxWidgetExtension
//
//  Created by Luis Fariña on 1/4/24.
//

extension Feed {

    // MARK: Properties

    var numberOfHoursUntilNewTimeline: Int {
        let numberOfHoursUntilNewTimeline: Int
        switch self {
        case .top, .new:
            numberOfHoursUntilNewTimeline = 3
        case .ask, .show:
            numberOfHoursUntilNewTimeline = 6
        case .best, .jobs:
            numberOfHoursUntilNewTimeline = 24
        }

        return numberOfHoursUntilNewTimeline
    }
}
