//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - LinkSetting

public struct LinkSetting<Icon: View, Label: View>: View {

    private let icon: Icon?
    private let label: Label
    private let destination: URL?

    @Environment(\.settingStyle) private var style

    public init(
        destination: URL,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label
    ) {
        self.destination = destination
        self.icon = icon()
        self.label = label()
    }

    public init(
        destination: URL,
        @ViewBuilder label: () -> Label
    ) {
        self.destination = destination
        self.icon = nil
        self.label = label()
    }

    public var body: some View {
        if let destination {
            if icon != nil {
                linkWithIcon(to: destination)
            } else {
                link(to: destination)
            }
        } else {
            Text("⚠️ Link missing")
        }
    }

    @ViewBuilder private func linkWithIcon(to destination: URL) -> some View {
        Link(destination: destination) {
            HStack {
                icon
                    .backgroundStyle(style.iconBackgroundColor ?? Color(.tertiaryLabel))
                    .foregroundStyle(style.iconForegroundColor ?? .inversePrimary)
                label
                    .foregroundStyle(style.titleColor ?? .primary)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
    }

    @ViewBuilder private func link(to destination: URL) -> some View {
        Link(destination: destination) {
            label
                .foregroundStyle(style.titleColor ?? .primary)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
        }
        .alignmentGuide(.listRowSeparatorLeading) { d in
            d[.leading]
        }
    }
}

// MARK: Icon: Never

extension LinkSetting where Icon == Never {

    public init(destination: URL, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.icon = nil
        self.label = label()
    }
}

// MARK: Label: Text

extension LinkSetting where Icon == Never, Label == Text {

    public init(_ titleKey: LocalizedStringKey, destination: URL) {
        self.init(
            destination: destination,
            label: {
                Text(titleKey)
            },
        )
    }

    public init<S: StringProtocol>(_ title: S, destination: URL) {
        self.init(
            destination: destination,
            label: {
                Text(title)
            }
        )
    }
}

// MARK: Icon: Image

extension LinkSetting where Icon == SettingIcon {

    public init(systemIcon: String, destination: URL, @ViewBuilder label: () -> Label) {
        self.init(
            destination: destination,
            icon: {
                SettingIcon(systemIcon)
            },
            label: {
                label()
            }
        )
    }
}

// MARK: Icon: Image, Label: Text

extension LinkSetting where Icon == SettingIcon, Label == Text {

    public init(_ titleKey: LocalizedStringKey, systemIcon: String, destination: URL) {
        self.init(
            destination: destination,
            icon: {
                SettingIcon(systemIcon)
            },
            label: {
                Text(titleKey)
            }
        )
    }

    public init<S: StringProtocol>(_ title: S, systemIcon: String, destination: URL) {
        self.init(
            destination: destination,
            icon: {
                SettingIcon(systemIcon)
            },
            label: {
                Text(title)
            }
        )
    }
}

// MARK: - Preview

#Preview {
    let url = URL(string: "https://example.com")!
    NavigationStack {
        Form {
            Section {
                LinkSetting("Title", destination: url)
                    .buttonStyle(.borderedProminent)
                    .transformSettingStyle { style in
                        style.withTitleColor(Color.white)
                    }
                LinkSetting("Title", systemIcon: "shippingbox.fill", destination: url)
                LinkSetting(destination: url) {
                    Text("Title").fontWeight(.semibold)
                }
                LinkSetting(systemIcon: "shippingbox.fill", destination: url) {
                    Text("Title").fontWeight(.semibold)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationDestination(for: Int.self) { value in
            Text("Destination \(value)")
        }
    }
}
