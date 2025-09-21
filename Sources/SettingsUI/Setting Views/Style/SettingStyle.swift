//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - Setting Style

/// A style configuration for setting rows that defines their appearance.
///
/// `SettingStyle` provides a way to customize the visual appearance of setting rows.
/// This style can be applied through the SwiftUI environment to affect all setting rows within
/// a view hierarchy.
///
/// ## Usage
///
/// ```swift
/// let customStyle = SettingStyle(
///     iconForegroundColor: .white,
///     iconBackgroundColor: .blue,
///     titleColor: .primary,
///     infoColor: .secondary
///     chevronColor: .secondary
/// )
///
/// PushSetting("Title", systemIcon: "shippingbox.fill", value: 6)
///     .settingStyle(customStyle)
/// ```
public struct SettingStyle: Equatable, Sendable {

    /// The foreground color used for the icon symbol.
    public var iconForegroundColor: Color?

    /// The background color used behind the icon.
    public var iconBackgroundColor: Color?

    /// The color applied to the primary title text of a setting row.
    public var titleColor: Color?

    /// The color applied to secondary informational text in a setting row.
    public var infoColor: Color?

    /// The color used for the trailing chevron indicator in navigable rows.
    public var chevronColor: Color?

    public var tintColor: Color?

    public var destructiveColor: Color?

    /// Creates a new setting environment style.
    ///
    /// - Parameters:
    ///   - iconForegroundColor: The color to use for the icon symbol.
    ///   - iconBackgroundColor: The color to use for the icon background.
    ///   - titleColor: The color to use for the row title text.
    ///   - infoColor: The color to use for secondary information text associated with a row,
    ///                such as descriptions or supplementary values.
    ///   - chevronColor: The color to use for the trailing chevron indicator that denotes
    ///                   navigable rows.
    public init(
        iconForegroundColor: Color? = nil, //.primary,
        iconBackgroundColor: Color? = nil, //Color(.systemBackground),
        titleColor: Color? = nil, //.primary,
        infoColor: Color? = nil, //.secondary,
        chevronColor: Color? = nil, //.secondary,
        tintColor: Color? = nil,
        destructiveColor: Color? = nil
    ) {
        self.iconForegroundColor = iconForegroundColor
        self.iconBackgroundColor = iconBackgroundColor
        self.titleColor = titleColor
        self.infoColor = infoColor
        self.chevronColor = chevronColor
        self.tintColor = tintColor
        self.destructiveColor = destructiveColor
    }

    /// Returns a copy of the style with a new icon foreground color.
    ///
    /// - Parameter color: The color to apply to the icon's foreground (symbol) layer.
    /// - Returns: A modified `SettingStyle` with the provided icon foreground color.
    ///
    public func withIconForegroundColor(_ color: Color?) -> SettingStyle {
        withChange { $0.iconForegroundColor = color }
    }

    /// Returns a copy of the style with a new icon background color.
    ///
    /// - Parameter color: The color to apply behind the icon.
    /// - Returns: A modified `SettingStyle` with the provided icon background color.
    ///
    public func withIconBackgroundColor(_ color: Color?) -> SettingStyle {
        withChange { $0.iconBackgroundColor = color }
    }

    /// Returns a copy of the style with a new title color.
    ///
    /// - Parameter color: The color to apply to the primary title text.
    /// - Returns: A modified `SettingStyle` with the provided title color.
    ///
    public func withTitleColor(_ color: Color?) -> SettingStyle {
        withChange { $0.titleColor = color }
    }

    /// Returns a copy of the style with a new info color.
    ///
    /// - Parameter color: The color to apply to secondary informational text.
    /// - Returns: A modified `SettingStyle` with the provided info color.
    ///
    public func withInfoColor(_ color: Color?) -> SettingStyle {
        withChange { $0.infoColor = color }
    }

    /// Returns a copy of the style with a new chevron color.
    ///
    /// - Parameter color: The color to apply to the trailing chevron indicator.
    /// - Returns: A modified `SettingStyle` with the provided chevron color.
    ///
    public func withChevronColor(_ color: Color?) -> SettingStyle {
        withChange { $0.chevronColor = color }
    }

    public func withTintColor(_ color: Color?) -> SettingStyle {
        withChange { $0.tintColor = color }
    }

    public func withDestructiveColor(_ color: Color?) -> SettingStyle {
        withChange { $0.destructiveColor = color }
    }

    /// Produces a modified copy of the style by applying a mutation block.
    ///
    /// - Parameter change: A closure that receives an inout copy of the style to mutate.
    /// - Returns: The mutated copy of `SettingStyle`.
    ///
    public func withChange(_ change: (inout SettingStyle) -> Void) -> SettingStyle {
        var style = self
        change(&style)
        return style
    }

    /// The default style used when no explicit `SettingStyle` is provided.
    public static let defaultStyle = SettingStyle()
}

// MARK: - Environment Value

/// Extension to add the setting environment style to the SwiftUI environment.
///
/// This extension uses the `@Entry` macro to create a new environment value that can be
/// accessed throughout the view hierarchy.
///
extension EnvironmentValues {
    /// The setting environment style available in the SwiftUI environment.
    ///
    /// Use this environment value to access the current setting style configuration
    /// within your views.
    ///
    @Entry public var settingStyle = SettingStyle()
}

// MARK: - View Modifier

/// View extension providing convenience methods for setting environment styles.
public extension View {

    /// Sets the setting style for this view and its descendants.
    ///
    /// - Parameter style: The `SettingStyle` to apply.
    /// - Returns: A view with the specified setting environment style applied.
    ///
    func settingStyle(_ style: SettingStyle) -> some View {
        environment(\.settingStyle, style)
    }

    /// Transforms the current `SettingStyle` for this view hierarchy.
    ///
    /// - Parameter change: A closure that takes the current style and returns a modified copy.
    /// - Returns: A view with the transformed `SettingStyle` applied to the environment.
    func transformSettingStyle(_ change: @escaping (SettingStyle) -> SettingStyle) -> some View {
        transformEnvironment(\.settingStyle) { style in
            style = change(style)
        }
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
            .settingStyle(
                SettingStyle(
                    iconForegroundColor: .inversePrimary,
                    iconBackgroundColor: .blue,
                    titleColor: .primary,
                    infoColor: .secondary
                )
            )
        }
        .navigationTitle("Settings")
        .navigationDestination(for: Int.self) { value in
            Text("Destination \(value)")
        }
    }
}
