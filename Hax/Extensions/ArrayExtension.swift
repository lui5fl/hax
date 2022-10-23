//
//  ArrayExtension.swift
//  Hax
//
//  Created by Luis Fariña on 10/5/22.
//

extension Array {

    subscript(safe index: Int) -> Element? {
        guard
            index >= 0,
            index < endIndex
        else {
            return nil
        }

        return self[index]
    }
}
