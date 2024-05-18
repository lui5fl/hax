//
//  SequenceExtension.swift
//  Hax
//
//  Created by Luis Fariña on 4/5/24.
//

extension Sequence {

    // MARK: Methods

    func compacted<T>() -> [T] where Element == T? {
        compactMap {
            $0
        }
    }

    /// [Source](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map)
    func concurrentMap<T: Sendable>(
        _ transform: @escaping @Sendable (Element) async throws -> T
    ) async throws -> [T] where Element: Sendable {
        try await map { element in
            Task {
                try await transform(element)
            }
        }
        .map { task in
            try await task.value
        }
    }

    /// [Source](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map)
    func map<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var elements = [T]()

        for element in self {
            try await elements.append(transform(element))
        }

        return elements
    }
}
