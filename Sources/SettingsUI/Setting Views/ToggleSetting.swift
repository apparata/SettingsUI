//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - ToggleSetting

public struct ToggleSetting<Icon: View, Label: View>: View {

    private let icon: Icon?
    private let label: Label
    @Binding private var isOn: Bool

    @Environment(\.settingStyle) private var style

    public init(
        isOn: Binding<Bool>,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label
    ) {
        self._isOn = isOn
        self.icon = icon()
        self.label = label()
    }

    public init(
        isOn: Binding<Bool>,
        @ViewBuilder label: () -> Label
    ) {
        self._isOn = isOn
        self.icon = nil
        self.label = label()
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                icon
                    .backgroundStyle(style.iconBackgroundColor ?? Color(.tertiaryLabel))
                    .foregroundStyle(style.iconForegroundColor ?? .inversePrimary)
                label
                    .foregroundStyle(style.titleColor ?? .primary)
            }
        }
    }
}

// MARK: Icon: Never

extension ToggleSetting where Icon == Never {

    public init(isOn: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self._isOn = isOn
        self.icon = nil
        self.label = label()
    }
}

// MARK: Label: Text

extension ToggleSetting where Icon == Never, Label == Text {

    public init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>) {
        self.init(isOn: isOn) {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(_ title: S, isOn: Binding<Bool>) {
        self.init(isOn: isOn) {
            Text(title)
        }
    }
}

// MARK: Icon: Image

extension ToggleSetting where Icon == SettingIcon {

    public init(isOn: Binding<Bool>, systemIcon: String, @ViewBuilder label: () -> Label) {
        self.init(isOn: isOn) {
                SettingIcon(systemIcon)
            } label: {
                label()
            }
    }
}

// MARK: Icon: Image, Label: Text

extension ToggleSetting where Icon == SettingIcon, Label == Text {

    public init(_ titleKey: LocalizedStringKey, systemIcon: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn) {
            SettingIcon(systemIcon)
        } label: {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(_ title: S, systemIcon: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn) {
            SettingIcon(systemIcon)
        } label: {
            Text(title)
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var isOn: Bool = false
    NavigationStack {
        Form {
            Section {
                ToggleSetting("Title", isOn: $isOn)
                ToggleSetting("Title", systemIcon: "shippingbox.fill", isOn: $isOn)
                ToggleSetting(isOn: $isOn) {
                    Text("Title").fontWeight(.semibold)
                }
                ToggleSetting(isOn: $isOn, systemIcon: "shippingbox.fill") {
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
