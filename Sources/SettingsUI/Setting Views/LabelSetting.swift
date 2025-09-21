//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - LabelSetting

public struct LabelSetting<Icon: View, Label: View, Info: View>: View {

    private let icon: Icon?
    private let label: Label
    private let info: Info?

    @Environment(\.settingStyle) private var style

    public init(
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label,
        @ViewBuilder info: () -> Info,
    ) {
        self.icon = icon()
        self.label = label()
        self.info = info()
    }

    public init(
        @ViewBuilder label: () -> Label
    ) {
        self.icon = nil
        self.label = label()
        self.info = nil
    }

    public init(
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label
    ) {
        self.icon = icon()
        self.label = label()
        self.info = nil
    }

    public init(
        @ViewBuilder label: () -> Label,
        @ViewBuilder info: () -> Info
    ) {
        self.icon = nil
        self.label = label()
        self.info = info()
    }

    public var body: some View {
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

// MARK: Icon: Never

extension LabelSetting where Icon == Never, Info == Never {

    public init(@ViewBuilder label: () -> Label) {
        self.icon = nil
        self.label = label()
        self.info = nil
    }
}

// MARK: Label: Text

extension LabelSetting where Icon == Never, Label == Text, Info == Never {

    public init(_ titleKey: LocalizedStringKey) {
        self.init {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(_ title: S) {
        self.init {
            Text(title)
        }
    }
}

// MARK: Label: Text, Info: Text

extension LabelSetting where Icon == Never, Label == Text, Info == Text {

    public init(_ titleKey: LocalizedStringKey, info: LocalizedStringKey) {
        self.icon = nil
        self.label = Text(titleKey)
        self.info = Text(info)
    }

    public init<S: StringProtocol>(_ titleKey: LocalizedStringKey, info: S) {
        self.icon = nil
        self.label = Text(titleKey)
        self.info = Text(info)
    }

    public init<S: StringProtocol>(_ titleKey: S, info: LocalizedStringKey) {
        self.icon = nil
        self.label = Text(titleKey)
        self.info = Text(info)
    }

    public init<S: StringProtocol, S2: StringProtocol>(_ title: S, info: S2) {
        self.icon = nil
        self.label = Text(title)
        self.info = Text(info)
    }
}

// MARK: Icon: Image

extension LabelSetting where Icon == SettingIcon, Info == Never {

    public init(systemIcon: String, @ViewBuilder label: () -> Label) {
        self.init {
                SettingIcon(systemIcon)
            } label: {
                label()
            }
    }
}

// MARK: Icon: Image, Label: Text

extension LabelSetting where Icon == SettingIcon, Label == Text, Info == Never {

    public init(_ titleKey: LocalizedStringKey, systemIcon: String) {
        self.init {
            SettingIcon(systemIcon)
        } label: {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(_ title: S, systemIcon: String) {
        self.init {
            SettingIcon(systemIcon)
        } label: {
            Text(title)
        }
    }
}

// MARK: Label: Text, Info: Text

extension LabelSetting where Icon == SettingIcon, Label == Text, Info == Text {

    public init(_ titleKey: LocalizedStringKey, systemIcon: String, info: LocalizedStringKey) {
        self.icon = SettingIcon(systemIcon)
        self.label = Text(titleKey)
        self.info = Text(info)
    }

    public init<S: StringProtocol>(_ titleKey: LocalizedStringKey, systemIcon: String, info: S) {
        self.icon = SettingIcon(systemIcon)
        self.label = Text(titleKey)
        self.info = Text(info)
    }

    public init<S: StringProtocol>(_ titleKey: S, systemIcon: String, info: LocalizedStringKey) {
        self.icon = SettingIcon(systemIcon)
        self.label = Text(titleKey)
        self.info = Text(info)
    }

    public init<S: StringProtocol, S2: StringProtocol>(_ title: S, systemIcon: String, info: S2) {
        self.icon = SettingIcon(systemIcon)
        self.label = Text(title)
        self.info = Text(info)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Form {
            Section {
                LabelSetting("Title")
                LabelSetting("Title", info: "Info")
                LabelSetting("Title", systemIcon: "shippingbox.fill")
                LabelSetting {
                    Text("Title").fontWeight(.semibold)
                }
                LabelSetting(systemIcon: "shippingbox.fill") {
                    Text("Title").fontWeight(.semibold)
                }
                LabelSetting("Title", systemIcon: "shippingbox.fill", info: "Info")
            }
        }
        .navigationTitle("Settings")
        .navigationDestination(for: Int.self) { value in
            Text("Destination \(value)")
        }
    }
}
