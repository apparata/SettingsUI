//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - TextFieldSetting

public struct TextFieldSetting<Icon: View, Label: View>: View {

    private let icon: Icon?
    private let label: Label
    @Binding private var value: String
    private let placeholder: String
    private let formatter: Formatter?
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void

    @Environment(\.settingStyle) private var style

    public init(
        value: Binding<String>,
        placeholder: String = "",
        formatter: Formatter? = nil,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self._value = value
        self.placeholder = placeholder
        self.formatter = formatter
        self.icon = icon()
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    public init(
        value: Binding<String>,
        placeholder: String = "",
        formatter: Formatter? = nil,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self._value = value
        self.placeholder = placeholder
        self.formatter = formatter
        self.icon = nil
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    public var body: some View {
        HStack {
            icon
                .backgroundStyle(style.iconBackgroundColor ?? Color(.tertiaryLabel))
                .foregroundStyle(style.iconForegroundColor ?? .inversePrimary)
            label
                .foregroundStyle(style.titleColor ?? .primary)
            Spacer()
            if let formatter = formatter {
                TextField(placeholder, value: $value, formatter: formatter, onEditingChanged: onEditingChanged, onCommit: onCommit)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: 200)
                    .textFieldStyle(.roundedBorder)
            } else {
                TextField(placeholder, text: $value, onEditingChanged: onEditingChanged, onCommit: onCommit)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: 200)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}

// MARK: Icon: Never

extension TextFieldSetting where Icon == Never {

    public init(
        value: Binding<String>,
        placeholder: String = "",
        formatter: Formatter? = nil,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self._value = value
        self.icon = nil
        self.label = label()
        self.placeholder = placeholder
        self.formatter = formatter
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
}

// MARK: Label: Text

extension TextFieldSetting where Icon == Never, Label == Text {

    public init(
        _ titleKey: LocalizedStringKey,
        value: Binding<String>,
        placeholder: String = "",
        formatter: Formatter? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            value: value,
            placeholder: placeholder,
            formatter: formatter,
            label: { Text(titleKey) },
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    public init<S: StringProtocol>(
        _ title: S,
        value: Binding<String>,
        placeholder: String = "",
        formatter: Formatter? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            value: value,
            placeholder: placeholder,
            formatter: formatter,
            label: { Text(title) },
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }
}

// MARK: Icon: Image

extension TextFieldSetting where Icon == SettingIcon {

    public init(
        value: Binding<String>,
        placeholder: String = "",
        formatter: Formatter? = nil,
        systemIcon: String,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            value: value,
            placeholder: placeholder,
            formatter: formatter,
            icon: { SettingIcon(systemIcon) },
            label: { label() },
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }
}

// MARK: Icon: Image, Label: Text

extension TextFieldSetting where Icon == SettingIcon, Label == Text {

    public init(
        _ titleKey: LocalizedStringKey,
        systemIcon: String,
        value: Binding<String>,
        placeholder: String = "",
        formatter: Formatter? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            value: value,
            placeholder: placeholder,
            formatter: formatter,
            icon: { SettingIcon(systemIcon) },
            label: { Text(titleKey) },
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    public init<S: StringProtocol>(
        _ title: S,
        systemIcon: String,
        value: Binding<String>,
        placeholder: String = "",
        formatter: Formatter? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            value: value,
            placeholder: placeholder,
            formatter: formatter,
            icon: { SettingIcon(systemIcon) },
            label: { Text(title) },
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var value: String = ""
    NavigationStack {
        Form {
            Section {
                TextFieldSetting("Title", value: $value)
                TextFieldSetting("Title", systemIcon: "shippingbox.fill", value: $value)
                TextFieldSetting(value: $value) {
                    Text("Title").fontWeight(.semibold)
                }
                TextFieldSetting(value: $value, systemIcon: "shippingbox.fill") {
                    Text("Title").fontWeight(.semibold)
                }
                TextFieldSetting("Title", value: $value, placeholder: "Placeholder")
            }
            .settingStyle(
                SettingStyle(
                    iconForegroundColor: .inversePrimary,
                    iconBackgroundColor: .blue
                )
            )
        }
        .navigationTitle("Settings")
        .navigationDestination(for: Int.self) { value in
            Text("Destination \(value)")
        }
    }
}
