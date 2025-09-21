//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - PushSetting

public struct PushSetting<Icon: View, Label: View, Info: View, Value: Hashable>: View {

    private let icon: Icon?
    private let label: Label
    private let info: Info?
    private let value: Value?

    @Environment(\.settingStyle) private var style

    public init(
        value: Value?,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label,
        @ViewBuilder info: () -> Info,
    ) {
        self.icon = icon()
        self.label = label()
        self.info = info()
        self.value = value
    }

    public init(
        value: Value?,
        @ViewBuilder label: () -> Label
    ) {
        self.icon = nil
        self.label = label()
        self.info = nil
        self.value = value
    }

    public init(
        value: Value?,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label
    ) {
        self.icon = icon()
        self.label = label()
        self.info = nil
        self.value = value
    }

    public init(
        value: Value?,
        @ViewBuilder label: () -> Label,
        @ViewBuilder info: () -> Info
    ) {
        self.icon = nil
        self.label = label()
        self.info = info()
        self.value = value
    }

    public var body: some View {
        NavigationLink(value: value) {
            HStack {
                icon
                    .backgroundStyle(style.iconBackgroundColor ?? Color(.tertiaryLabel))
                    .foregroundStyle(style.iconForegroundColor ?? .inversePrimary)
                label
                    .foregroundStyle(style.titleColor ?? .primary)
                Spacer()
                info
                    .foregroundStyle(style.infoColor ?? .secondary)
            }
        }
    }
}

// MARK: Icon: Never

extension PushSetting where Icon == Never, Info == Never {

    public init(value: Value?, @ViewBuilder label: () -> Label) {
        self.icon = nil
        self.label = label()
        self.info = nil
        self.value = value
    }
}

// MARK: Label: Text

extension PushSetting where Icon == Never, Label == Text, Info == Never {

    public init(_ titleKey: LocalizedStringKey, value: Value?) {
        self.init(value: value) {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(_ title: S, value: Value?) {
        self.init(value: value) {
            Text(title)
        }
    }
}

// MARK: Label: Text, Info: Text

extension PushSetting where Icon == Never, Label == Text, Info == Text {

    public init(_ titleKey: LocalizedStringKey, info: LocalizedStringKey, value: Value?) {
        self.icon = nil
        self.label = Text(titleKey)
        self.info = Text(info)
        self.value = value
    }

    public init<S: StringProtocol>(_ titleKey: LocalizedStringKey, info: S, value: Value?) {
        self.icon = nil
        self.label = Text(titleKey)
        self.info = Text(info)
        self.value = value
    }

    public init<S: StringProtocol>(_ titleKey: S, info: LocalizedStringKey, value: Value?) {
        self.icon = nil
        self.label = Text(titleKey)
        self.info = Text(info)
        self.value = value
    }

    public init<S: StringProtocol, S2: StringProtocol>(_ title: S, info: S2, value: Value?) {
        self.icon = nil
        self.label = Text(title)
        self.info = Text(info)
        self.value = value
    }
}

// MARK: Icon: Image

extension PushSetting where Icon == SettingIcon, Info == Never {

    public init(value: Value?, systemIcon: String, @ViewBuilder label: () -> Label) {
        self.init(value: value) {
                SettingIcon(systemIcon)
            } label: {
                label()
            }
    }
}

// MARK: Icon: Image, Label: Text

extension PushSetting where Icon == SettingIcon, Label == Text, Info == Never {

    public init(_ titleKey: LocalizedStringKey, systemIcon: String, value: Value?) {
        self.init(value: value) {
            SettingIcon(systemIcon)
        } label: {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(_ title: S, systemIcon: String, value: Value?) {
        self.init(value: value) {
            SettingIcon(systemIcon)
        } label: {
            Text(title)
        }
    }
}

// MARK: Label: Text, Info: Text

extension PushSetting where Icon == SettingIcon, Label == Text, Info == Text {

    public init(_ titleKey: LocalizedStringKey, systemIcon: String, info: LocalizedStringKey, value: Value?) {
        self.icon = SettingIcon(systemIcon)
        self.label = Text(titleKey)
        self.info = Text(info)
        self.value = value
    }

    public init<S: StringProtocol>(_ titleKey: LocalizedStringKey, systemIcon: String, info: S, value: Value?) {
        self.icon = SettingIcon(systemIcon)
        self.label = Text(titleKey)
        self.info = Text(info)
        self.value = value
    }

    public init<S: StringProtocol>(_ titleKey: S, systemIcon: String, info: LocalizedStringKey, value: Value?) {
        self.icon = SettingIcon(systemIcon)
        self.label = Text(titleKey)
        self.info = Text(info)
        self.value = value
    }

    public init<S: StringProtocol, S2: StringProtocol>(_ title: S, systemIcon: String, info: S2, value: Value?) {
        self.icon = SettingIcon(systemIcon)
        self.label = Text(title)
        self.info = Text(info)
        self.value = value
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Form {
            Section {
                PushSetting("Title", value: 1)
                PushSetting("Title", info: "Info", value: 2)
                PushSetting("Title", systemIcon: "shippingbox.fill", value: 3)
                PushSetting(value: 4) {
                    Text("Title").fontWeight(.semibold)
                }
                PushSetting(value: 5, systemIcon: "shippingbox.fill") {
                    Text("Title").fontWeight(.semibold)
                }
                PushSetting("Title", systemIcon: "shippingbox.fill", info: "Info", value: 6)
            }
        }
        .navigationTitle("Settings")
        .navigationDestination(for: Int.self) { value in
            Text("Destination \(value)")
        }
    }
}
