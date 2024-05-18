//
//  ActivityIndicatorView.swift
//  Hax
//
//  Created by Luis Fariña on 26/5/22.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.startAnimating()

        return view
    }

    func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: Context
    ) {
        // Do nothing
    }
}
