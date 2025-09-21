//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - PickerSetting

/// A setting view for picking a value from a collection.
///
/// Values must conform to `SettingPickable`.
///
/// **Example:**
///
/// ```
/// public enum APIEnvironment: String, CaseIterable {
///     case development = "Development"
///     case staging = "Staging"
///     case production = "Production"
/// }
///
/// PickerSetting(
///     "API Environment",
///     values: APIEnvironment.allCases,
///     selection: $settings.apiEnvironment
/// )
/// ```
///
/// **Example with CaseIterable Enum:**
///
/// ```
/// PickerSetting(
///     "API Environment",
///     selection: $settings.apiEnvironment
/// )
/// ```
///
public struct PickerSetting<Icon: View, Label: View, T: SettingPickable>: View {

    private let icon: Icon?
    private let label: Label
    private let values: [T]
    @Binding private var selection: T

    @Environment(\.settingStyle) private var style

    public init(
        values: [T],
        selection: Binding<T>,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label
    ) {
        self.values = values
        self._selection = selection
        self.icon = icon()
        self.label = label()
    }

    public init(
        values: [T],
        selection: Binding<T>,
        @ViewBuilder label: () -> Label
    ) {
        self.values = values
        self._selection = selection
        self.icon = nil
        self.label = label()
    }

    public var body: some View {
        Picker(selection: $selection, label: HStack {
            icon
                .backgroundStyle(style.iconBackgroundColor ?? Color(.tertiaryLabel))
                .foregroundStyle(style.iconForegroundColor ?? .inversePrimary)
            label
                .foregroundStyle(style.titleColor ?? .primary)
            Spacer()
        }) {
            ForEach(values) { value in
                Text(value.description)
                    .tag(value)
            }
        }
    }
}

// MARK: T: CaseIterable

extension PickerSetting where T: CaseIterable {
    public init(
        selection: Binding<T>,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder label: () -> Label
    ) {
        self.values = Array(T.allCases)
        self._selection = selection
        self.icon = icon()
        self.label = label()
    }

    public init(
        selection: Binding<T>,
        @ViewBuilder label: () -> Label
    ) {
        self.values = Array(T.allCases)
        self._selection = selection
        self.icon = nil
        self.label = label()
    }
}

// MARK: Icon: Never

extension PickerSetting where Icon == Never {

    public init(
        values: [T],
        selection: Binding<T>,
        @ViewBuilder label: () -> Label
    ) {
        self.values = values
        self._selection = selection
        self.icon = nil
        self.label = label()
    }
}

extension PickerSetting where Icon == Never, T: CaseIterable {

    public init(
        selection: Binding<T>,
        @ViewBuilder label: () -> Label
    ) {
        self.values = Array(T.allCases)
        self._selection = selection
        self.icon = nil
        self.label = label()
    }
}


// MARK: Label: Text

extension PickerSetting where Icon == Never, Label == Text {

    public init(
        _ titleKey: LocalizedStringKey,
        values: [T],
        selection: Binding<T>
    ) {
        self.init(values: values, selection: selection) {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(
        _ title: S,
        values: [T],
        selection: Binding<T>
    ) {
        self.init(values: values, selection: selection) {
            Text(title)
        }
    }
}

extension PickerSetting where Icon == Never, Label == Text, T: CaseIterable {

    public init(
        _ titleKey: LocalizedStringKey,
        selection: Binding<T>
    ) {
        self.init(selection: selection) {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(
        _ title: S,
        selection: Binding<T>
    ) {
        self.init(selection: selection) {
            Text(title)
        }
    }
}

// MARK: Icon: Image

extension PickerSetting where Icon == SettingIcon {

    public init(
        values: [T],
        selection: Binding<T>,
        systemIcon: String,
        @ViewBuilder label: () -> Label
    ) {
        self.init(values: values, selection: selection) {
                SettingIcon(systemIcon)
            } label: {
                label()
            }
    }
}

extension PickerSetting where Icon == SettingIcon, T: CaseIterable {

    public init(
        selection: Binding<T>,
        systemIcon: String,
        @ViewBuilder label: () -> Label
    ) {
        self.init(selection: selection) {
            SettingIcon(systemIcon)
        } label: {
            label()
        }
    }
}

// MARK: Icon: Image, Label: Text

extension PickerSetting where Icon == SettingIcon, Label == Text {

    public init(
        _ titleKey: LocalizedStringKey,
        systemIcon: String,
        values: [T],
        selection: Binding<T>
    ) {
        self.init(values: values, selection: selection) {
            SettingIcon(systemIcon)
        } label: {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(
        _ title: S,
        systemIcon: String,
        values: [T],
        selection: Binding<T>,
    ) {
        self.init(values: values, selection: selection) {
            SettingIcon(systemIcon)
        } label: {
            Text(title)
        }
    }
}

extension PickerSetting where Icon == SettingIcon, Label == Text, T: CaseIterable {

    public init(
        _ titleKey: LocalizedStringKey,
        systemIcon: String,
        selection: Binding<T>
    ) {
        self.init(selection: selection) {
            SettingIcon(systemIcon)
        } label: {
            Text(titleKey)
        }
    }

    public init<S: StringProtocol>(
        _ title: S,
        systemIcon: String,
        selection: Binding<T>,
    ) {
        self.init(selection: selection) {
            SettingIcon(systemIcon)
        } label: {
            Text(title)
        }
    }
}


// MARK: - Preview

#if DEBUG
// Only for preview.
private enum APIEnvironment: String, SettingPickable, CaseIterable {
    case development = "Development"
    case staging = "Staging"
    case production = "Production"

    var id: APIEnvironment { self }
    var description: String {
        rawValue
    }
}
#endif

#Preview {

    @Previewable @State var selection: APIEnvironment = .development
    NavigationStack {
        Form {
            Section {
                PickerSetting(
                    "Title",
                    values: APIEnvironment.allCases,
                    selection: $selection
                )
                PickerSetting(
                    "Title",
                    systemIcon: "shippingbox.fill",
                    values: APIEnvironment.allCases,
                    selection: $selection
                )
                PickerSetting(
                    values: APIEnvironment.allCases,
                    selection: $selection
                ) {
                    Text("Title").fontWeight(.semibold)
                }
                PickerSetting(
                    values: APIEnvironment.allCases,
                    selection: $selection,
                    systemIcon: "shippingbox.fill"
                ) {
                    Text("Title").fontWeight(.semibold)
                }
            }

            Section("CaseIterable Enum") {
                PickerSetting("Title", selection: $selection)
                PickerSetting(
                    "Title",
                    systemIcon: "shippingbox.fill",
                    selection: $selection
                )
                PickerSetting(selection: $selection) {
                    Text("Title").fontWeight(.semibold)
                }
                PickerSetting(
                    selection: $selection,
                    systemIcon: "shippingbox.fill"
                ) {
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
