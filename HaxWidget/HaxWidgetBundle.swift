//
//  HaxWidgetBundle.swift
//  HaxWidget
//
//  Created by Luis Fariña on 17/9/23.
//

import SwiftUI
import WidgetKit

@main
struct HaxWidgetBundle: WidgetBundle {

    // MARK: Body

    var body: some Widget {
        if #available(iOS 18.0, *) {
            return iOS18Body
        } else {
            return iOS17Body
        }
    }
}

// MARK: - Private extension

private extension HaxWidgetBundle {

    // MARK: Properties

    @WidgetBundleBuilder
    @available(iOSApplicationExtension 18.0, *)
    var iOS18Body: some Widget {
        HaxWidget()
        HaxWidgetControl()
    }

    @WidgetBundleBuilder
    var iOS17Body: some Widget {
        HaxWidget()
    }
}
