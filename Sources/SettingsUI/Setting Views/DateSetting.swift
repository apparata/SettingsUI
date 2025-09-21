//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - DateSetting

public struct DateSetting<Label: View>: View {

    private let icon: SettingIcon?
    private let label: Label

    @Binding private var date: Date

    // Optional bounds and components to control the picker behavior.
    private let range: ClosedRange<Date>?
    private let displayedComponents: DatePickerComponents

    @Environment(\.settingStyle) private var style

    public var body: some View {
        HStack {
            icon?
                .backgroundStyle(style.iconBackgroundColor ?? Color(.tertiaryLabel))
                .foregroundStyle(style.iconForegroundColor ?? .inversePrimary)
            label
                .foregroundStyle(style.titleColor ?? .primary)
            Spacer()
            DatePicker(
                "",
                selection: $date,
                in: range ?? Date.distantPast...Date.distantFuture,
                displayedComponents: displayedComponents
            )
            .labelsHidden()
        }
    }

    /// Designated initializer matching the SwitchSetting style.
    public init(
        label: Label,
        date: Binding<Date>,
        icon: SettingIcon? = nil,
        in range: ClosedRange<Date>? = nil,
        displayedComponents: DatePickerComponents = [.date]
    ) {
        self.label = label
        self._date = date
        self.icon = icon
        self.range = range
        self.displayedComponents = displayedComponents
    }
}

// MARK: - Label: Text

extension DateSetting where Label == Text {

    public init(
        _ titleKey: LocalizedStringKey,
        date: Binding<Date>,
        icon: SettingIcon? = nil,
        in range: ClosedRange<Date>? = nil,
        displayedComponents: DatePickerComponents = [.date]
    ) {
        self.label = Text(titleKey)
        self._date = date
        self.icon = icon
        self.range = range
        self.displayedComponents = displayedComponents
    }

    public init<S: StringProtocol>(
        _ title: S,
        date: Binding<Date>,
        icon: SettingIcon? = nil,
        in range: ClosedRange<Date>? = nil,
        displayedComponents: DatePickerComponents = [.date]
    ) {
        self.label = Text(title)
        self._date = date
        self.icon = icon
        self.range = range
        self.displayedComponents = displayedComponents
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        Form {
            Section {
                DateSetting("Date", date: .constant(.now))
                DateSetting(
                    "Date & Time",
                    date: .constant(.now),
                    displayedComponents: [.date, .hourAndMinute]
                )
                DateSetting(
                    "Birthday",
                    date: .constant(.now),
                    icon: SettingIcon("gift"),
                    in: Calendar.current.date(byAdding: .year, value: -120, to: .now)! ... Date()
                )
            }
        }
        .navigationTitle("Settings")
    }
}
