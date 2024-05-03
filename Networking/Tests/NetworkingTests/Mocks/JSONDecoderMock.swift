//
//  JSONDecoderMock.swift
//
//
//  Created by Luis Fariña on 17/5/24.
//

import Foundation

final class JSONDecoderMock: JSONDecoder {

    // MARK: Properties

    private(set) var decodeCallCount = Int.zero

    // MARK: Methods

    override func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) throws -> T {
        decodeCallCount += 1

        return try super.decode(type, from: data)
    }
}
