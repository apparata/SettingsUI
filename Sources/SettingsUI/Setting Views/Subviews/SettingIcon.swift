//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - SettingIcon

/// A customizable icon view designed for settings and configuration interfaces.
///
/// `SettingIcon` provides a consistent way to display icons in settings screens and similar
/// interfaces. It automatically adapts its appearance based on the environment style and
/// supports both system images and custom named images.
///
/// The icon automatically scales with Dynamic Type and can display with or without a
/// rounded background depending on the environment style configuration.
///
/// ## Features
///
/// - Dynamic Type support with automatic scaling
/// - Customizable foreground and background colors via environment
/// - Support for both SF Symbols and custom images
/// - Automatic background rendering based on style opacity
/// - Consistent rounded corner styling
///
/// ## Usage
///
/// ```swift
/// // Basic usage with SF Symbol
/// SettingIcon("gear")
///
/// // With custom style
/// SettingIcon("bell")
///     .backgroundStyle(.red)
///     .foregroundStyle(.white)
///
/// // Using a custom image
/// SettingIcon(named: "my-custom-icon")
/// ```
public struct SettingIcon: View {

    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 24
    @ScaledMetric(relativeTo: .body) private var iconCornerRadius: CGFloat = 6

    @Environment(\.backgroundStyle) private var backgroundStyle

    private let image: Image

    /// Creates a setting icon using a system image name.
    ///
    /// This initializer creates an icon using SF Symbols system images. The icon will
    /// automatically adapt its appearance based on the current environment style.
    ///
    /// - Parameter systemImage: The name of the SF Symbol to display.
    ///
    /// ## Example
    ///
    /// ```swift
    /// SettingIcon("gear")        // Settings gear icon
    /// SettingIcon("bell")        // Notification bell icon
    /// SettingIcon("person")      // Person profile icon
    /// ```
    public init(_ systemImage: String) {
        self.image = Image(systemName: systemImage)
    }

    /// Creates a setting icon using a named image from the app bundle.
    ///
    /// This initializer creates an icon using a custom image from your app's bundle.
    /// The image will be styled according to the current environment configuration.
    ///
    /// - Parameter name: The name of the image in your app bundle.
    ///
    /// ## Example
    ///
    /// ```swift
    /// SettingIcon(named: "custom-settings-icon")
    /// ```
    public init(named name: String) {
        self.image = Image(name)
    }

    /// The body of the setting icon view.
    ///
    /// Renders the icon with appropriate styling based on the environment configuration.
    /// When a background color is specified (not fully transparent), the icon is displayed
    /// within a rounded rectangle background. Otherwise, it's displayed as a standalone icon.
    public var body: some View {
        RoundedRectangle(cornerRadius: iconCornerRadius, style: .continuous)
            .fill(backgroundStyle ?? AnyShapeStyle(Color(.systemBackground)))
            .frame(width: iconSize, height: iconSize)
            .overlay {
                VStack {
                    image
                        .imageScale(.small)
                }
            }
    }
}


// MARK: - Preview

#Preview {
    VStack {
        SettingIcon("trash")

        SettingIcon("trash")
            .backgroundStyle(.red)
            .foregroundStyle(.white)
    }
    .padding()
}
