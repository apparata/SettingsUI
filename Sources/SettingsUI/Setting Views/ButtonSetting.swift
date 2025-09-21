//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - ButtonSetting

public struct ButtonSetting<Icon: View, Label: View>: View {

    private let icon: Icon?
    private let label: Label
    private let action: () -> Void

    @Environment(\.settingStyle) private var style

    public init(
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label,
        action: @escaping () -> Void
    ) {
        self.icon = icon()
        self.label = label()
        self.action = action
    }

    public init(
        @ViewBuilder label: () -> Label,
        action: @escaping () -> Void
    ) {
        self.icon = nil
        self.label = label()
        self.action = action
    }

    public var body: some View {
        if let icon {
            Button(action: action) {
                HStack {
                    icon
                        .backgroundStyle(style.iconBackgroundColor ?? style.tintColor ?? Color(.tertiaryLabel))
                        .foregroundStyle(style.iconForegroundColor ?? .inversePrimary)
                    label
                        .tint(style.tintColor)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
        } else {
            Button(action: action) {
                label
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
            }
            .tint(style.tintColor)
            .alignmentGuide(.listRowSeparatorLeading) { d in
                d[.leading]
            }
        }
    }
}

// MARK: Icon: Never

extension ButtonSetting where Icon == Never {

    public init(@ViewBuilder label: () -> Label, action: @escaping () -> Void) {
        self.icon = nil
        self.label = label()
        self.action = action
    }
}

// MARK: Label: Text

extension ButtonSetting where Icon == Never, Label == Text {

    public init(_ titleKey: LocalizedStringKey, action: @escaping () -> Void) {
        self.init(
            label: {
                Text(titleKey)
            },
            action: action
        )
    }

    public init<S: StringProtocol>(_ title: S, action: @escaping () -> Void) {
        self.init(
            label: {
                Text(title)
            },
            action: action
        )
    }
}

// MARK: Icon: Image

extension ButtonSetting where Icon == SettingIcon {

    public init(systemIcon: String, @ViewBuilder label: () -> Label, action: @escaping () -> Void) {
        self.init(
            icon: {
                SettingIcon(systemIcon)
            },
            label: {
                label()
            },
            action: action
        )
    }
}

// MARK: Icon: Image, Label: Text

extension ButtonSetting where Icon == SettingIcon, Label == Text {

    public init(_ titleKey: LocalizedStringKey, systemIcon: String, action: @escaping () -> Void) {
        self.init(
            icon: {
                SettingIcon(systemIcon)
            },
            label: {
                Text(titleKey)
            },
            action: action
        )
    }

    public init<S: StringProtocol>(_ title: S, systemIcon: String, action: @escaping () -> Void) {
        self.init(
            icon: {
                SettingIcon(systemIcon)
            },
            label: {
                Text(title)
            },
            action: action
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Form {
            Section {
                ButtonSetting("Title") {
                    print("Action!")
                }
                .buttonStyle(.borderedProminent)
                ButtonSetting("Title", systemIcon: "shippingbox.fill") {
                    print("Action!")
                }
                ButtonSetting {
                    Text("Title").fontWeight(.semibold)
                } action: {
                    print("Action!")
                }
                ButtonSetting(systemIcon: "shippingbox.fill") {
                    Text("Title").fontWeight(.semibold)
                } action: {
                    print("Action!")
                }
            }
        }
        .navigationTitle("Settings")
        .navigationDestination(for: Int.self) { value in
            Text("Destination \(value)")
        }
    }
}
