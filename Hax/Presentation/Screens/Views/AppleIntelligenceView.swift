//
//  AppleIntelligenceView.swift
//  Hax
//
//  Created by Luis Fariña on 9/12/25.
//

import FoundationModels
import SwiftUI

@available(iOS 26.0, *)
struct AppleIntelligenceView: View {

    // MARK: Properties

    private let model = SystemLanguageModel.default

    @AppStorage(UserDefaults.Key.discussionAtAGlanceIsEnabled)
    private var discussionAtAGlanceIsEnabled = true

    // MARK: Body

    var body: some View {
        Form {
            availability

            Group {
                discussionAtAGlanceToggle
            }
            .disabled(!model.isAvailable)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Apple Intelligence")
    }
}

// MARK: - Private extension

@available(iOS 26.0, *)
private extension AppleIntelligenceView {

    // MARK: Properties

    var availability: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(availabilityColor)
                    Text(availabilityTitle)
                        .bold()
                }

                Text(availabilityDescription)
                    .foregroundStyle(.secondary)
            }
        }
    }

    var availabilityColor: Color {
        if model.isAvailable {
            .green
        } else {
            .red
        }
    }

    var availabilityTitle: LocalizedStringKey {
        if model.isAvailable {
            "Available"
        } else {
            "Unavailable"
        }
    }

    var availabilityDescription: LocalizedStringKey {
        switch model.availability {
        case .available:
            "Hax features using Apple Intelligence are available."
        case .unavailable(.deviceNotEligible):
            "This device does not support Apple Intelligence."
        case .unavailable(.appleIntelligenceNotEnabled):
            "Turn on Apple Intelligence."
        case .unavailable(.modelNotReady):
            """
            Apple Intelligence models are not available yet because \
            they are downloading or due to other system reasons.
            """
        case .unavailable:
            """
            Apple Intelligence models are unavailable for an \
            unknown reason.
            """
        }
    }

    var discussionAtAGlanceToggle: some View {
        Section {
            Toggle(
                "Discussion at a glance",
                isOn: $discussionAtAGlanceIsEnabled
            )
        } footer: {
            Text("Generate a summary of a story’s top comments.")
        }
    }
}

// MARK: - Previews

@available(iOS 26.0, *)
#Preview {
    NavigationStack {
        AppleIntelligenceView()
    }
}
