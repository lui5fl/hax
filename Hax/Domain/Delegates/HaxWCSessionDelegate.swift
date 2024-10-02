//
//  HaxWCSessionDelegate.swift
//  Hax
//
//  Created by Luis Fariña on 30/9/24.
//

import WatchConnectivity

final class HaxWCSessionDelegate: NSObject {

    // MARK: Properties

    var didReceiveApplicationContext: (
        @Sendable (_ applicationContext: [String: Any]) -> Void
    )?

    // MARK: Initialization

    override init() {
        super.init()

        guard WCSession.isSupported() else {
            return
        }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
}

// MARK: - WCSessionDelegate

extension HaxWCSessionDelegate: WCSessionDelegate {

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        // Do nothing
    }

#if !os(watchOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Do nothing
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Do nothing
    }
#endif

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        didReceiveApplicationContext?(applicationContext)
    }
}
