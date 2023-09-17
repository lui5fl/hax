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
        let numberOfItems: Int
        switch self {
        case .systemSmall:
            numberOfItems = 2
        case .systemMedium:
            numberOfItems = 4
        case .systemLarge:
            numberOfItems = 8
        default:
            numberOfItems = 1
        }

        return numberOfItems
    }

    var exampleItems: [Item] {
        (.zero..<numberOfItems).map(Item.example)
    }
}
