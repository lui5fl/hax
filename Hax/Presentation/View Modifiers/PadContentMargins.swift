//
//  PadContentMargins.swift
//  Hax
//
//  Created by Luis Fariña on 4/10/24.
//

import SwiftUI

struct PadContentMargins: ViewModifier {

    // MARK: Properties

    @Environment(
        \.horizontalSizeClass
    ) private var horizontalSizeClass

    // MARK: Body

    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            GeometryReader { proxy in
                let width = UIScreen.main.bounds.width
                let length: CGFloat? = if horizontalSizeClass == .regular,
                                          proxy.size.width > proxy.size.height {
                    (width - width * 2 / 3) / 2
                } else {
                    nil
                }
                content.contentMargins(
                    .horizontal,
                    length,
                    for: .scrollContent
                )
            }
        } else {
            content
        }
    }
}
