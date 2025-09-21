//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - SegmentedSetting

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
/// SegmentedSetting(
///     "API Environment",
///     values: APIEnvironment.allCases,
///     selection: $settings.apiEnvironment
/// )
/// ```
///
/// **Example with CaseIterable Enum:**
///
/// ```
/// SegmentedSetting(
///     "API Environment",
///     selection: $settings.apiEnvironment
/// )
/// ```
///
public struct SegmentedSetting<Label: View, T: SettingPickable>: View {

    private let label: Label
    private let values: [T]
    @Binding private var selection: T

    @Environment(\.settingStyle) private var style

    public init(
        values: [T],
        selection: Binding<T>,
        @ViewBuilder label: () -> Label
    ) {
        self.values = values
        self._selection = selection
        self.label = label()
    }

    public var body: some View {
        Picker(
            selection: $selection,
            label: label.foregroundStyle(style.titleColor ?? .primary)
        ) {
            ForEach(values) { value in
                Text(value.description)
                    .tag(value)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

// MARK: T: CaseIterable

extension SegmentedSetting where T: CaseIterable {
    public init(
        selection: Binding<T>,
        @ViewBuilder label: () -> Label
    ) {
        self.values = Array(T.allCases)
        self._selection = selection
        self.label = label()
    }
}


// MARK: Label: Text

extension SegmentedSetting where Label == Text {

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

extension SegmentedSetting where Label == Text, T: CaseIterable {

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
                SegmentedSetting(
                    "Title",
                    values: APIEnvironment.allCases,
                    selection: $selection
                )
                SegmentedSetting(
                    values: APIEnvironment.allCases,
                    selection: $selection
                ) {
                    Text("Title").fontWeight(.semibold)
                }
            }

            Section("CaseIterable Enum") {
                SegmentedSetting("Title", selection: $selection)
                SegmentedSetting(selection: $selection) {
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
