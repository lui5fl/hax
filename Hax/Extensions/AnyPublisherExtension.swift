//
//  AnyPublisherExtension.swift
//  Hax
//
//  Created by Luis Fariña on 17/9/23.
//

import Combine

extension AnyPublisher {

    // MARK: Methods

    /// [Source](https://medium.com/geekculture/from-combine-to-async-await-c08bf1d15b77)
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var finishedWithoutValue = true
            var cancellable: AnyCancellable?
            cancellable = first()
                .sink { completion in
                    switch completion {
                    case .finished:
                        if finishedWithoutValue {
                            continuation.resume(throwing: AsyncError.finishedWithoutValue)
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    finishedWithoutValue = false
                    continuation.resume(returning: value)
                }
        }
    }
}

// MARK: - Private extension

private extension AnyPublisher {

    // MARK: Types

    enum AsyncError: Error {

        // MARK: Cases

        case finishedWithoutValue
    }
}
