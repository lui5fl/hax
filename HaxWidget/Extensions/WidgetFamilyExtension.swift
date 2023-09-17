//
//  WidgetFamilyExtension.swift
//  HaxWidgetExtension
//
//  Created by Luis Fariña on 8/11/23.
//

import WidgetKit

extension WidgetFamily {

    // MARK: Properties

    var numberOfItems: Int {
        switch self {
        case .systemSmall:
            return 2
        case .systemMedium:
            return 4
        case .systemLarge:
            return 8
        default:
            return 1
        }
    }
}
