# SettingsUI

A Swift Package providing reusable SwiftUI views for creating elegant settings screens in iOS, macOS, visionOS, and tvOS applications.

## Overview

SettingsUI simplifies the creation of settings interfaces by providing a comprehensive collection of pre-built setting row components. Each component follows native platform conventions and supports extensive customization through a unified styling system.

## Features

- **Comprehensive Setting Types**: Toggle, button, picker, text field, date, link, and more
- **Unified Styling System**: Customize appearance across all setting components
- **Platform Support**: iOS 18+, macOS 15+, visionOS 2+, tvOS 18+
- **SwiftUI Native**: Built entirely with SwiftUI for seamless integration
- **Icon Support**: Built-in support for SF Symbols with customizable styling

## Quick Start

```swift
import SwiftUI
import SettingsUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var selectedTheme = Theme.system
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    ToggleSetting(
                        "Notifications",
                        systemIcon: "bell.fill",
                        isOn: $notificationsEnabled
                    )
                    
                    PickerSetting(
                        "Theme",
                        systemIcon: "paintbrush.fill",
                        selection: $selectedTheme
                    )
                    
                    ButtonSetting(
                        "Clear Cache",
                        systemIcon: "trash.fill"
                    ) {
                        // Clear cache action
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

enum Theme: String, SettingPickable, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var id: Theme { self }
    var description: String { rawValue }
}
```

## Available Components

### ToggleSetting

A toggle switch setting for boolean values.

```swift
// Basic toggle
ToggleSetting("Enable Feature", isOn: $isEnabled)

// With icon
ToggleSetting(
    "Notifications",
    systemIcon: "bell.fill",
    isOn: $notificationsEnabled
)
```

### ButtonSetting

A button that triggers an action when tapped.

```swift
// Basic button
ButtonSetting("Clear Cache") {
    clearCache()
}

// With icon and custom styling
ButtonSetting(
    "Sign Out",
    systemIcon: "rectangle.portrait.and.arrow.right"
) {
    signOut()
}
.buttonStyle(.borderedProminent)
```

### PickerSetting

A picker for selecting from a collection of values.

```swift
// With CaseIterable enum
PickerSetting("Theme", selection: $selectedTheme)

// With custom values array
PickerSetting(
    "Language",
    values: availableLanguages,
    selection: $selectedLanguage
)
```

Values must conform to `SettingPickable` (which combines `Identifiable`, `Hashable`, and `CustomStringConvertible`).

### TextFieldSetting

A text input field setting.

```swift
TextFieldSetting(
    "Username",
    text: $username,
    prompt: "Enter username"
)
```

### DateSetting

A date picker setting.

```swift
DateSetting(
    "Birthday",
    selection: $birthday,
    displayedComponents: .date
)
```

### LinkSetting

A setting that opens a URL or navigates to another view.

```swift
// External link
LinkSetting(
    "Privacy Policy",
    destination: URL(string: "https://example.com/privacy")!
)

// Navigation link
LinkSetting("Advanced Settings", value: AdvancedSettingsDestination())
```

### PushSetting

A setting that navigates to another view with optional info display.

```swift
PushSetting(
    "Account",
    info: "john@example.com",
    value: AccountDestination()
)
```

### LabelSetting

A read-only label setting for displaying information.

```swift
LabelSetting(
    "Version",
    value: Bundle.main.appVersion
)
```

### SegmentedSetting

A segmented control setting for selecting between options.

```swift
SegmentedSetting(
    "Size",
    selection: $selectedSize,
    options: Size.allCases
)
```

### DestructiveButtonSetting

A button with destructive styling for dangerous actions.

```swift
DestructiveButtonSetting("Delete Account") {
    deleteAccount()
}
```

## Styling System

SettingsUI provides a powerful styling system that allows you to customize the appearance of all setting components consistently.

### SettingStyle

Create custom styles by configuring colors for different components:

```swift
let customStyle = SettingStyle(
    iconForegroundColor: .white,
    iconBackgroundColor: .blue,
    titleColor: .primary,
    infoColor: .secondary,
    chevronColor: .secondary,
    tintColor: .blue,
    destructiveColor: .red
)
```

### Applying Styles

Apply styles to individual components or entire view hierarchies:

```swift
// Apply to a single setting
ToggleSetting("Feature", isOn: $isEnabled)
    .settingStyle(customStyle)

// Apply to an entire form section
Section("General") {
    // All settings in this section will use the custom style
    ToggleSetting("Feature 1", isOn: $feature1)
    ToggleSetting("Feature 2", isOn: $feature2)
}
.settingStyle(customStyle)

// Transform existing style
Form {
    // Settings content
}
.transformSettingStyle { style in
    style.withTintColor(.blue)
         .withIconBackgroundColor(.secondary)
}
```

### Style Properties

All style properties have reasonable default values, but they can be configured.

- **iconForegroundColor**: Color for icon symbols
- **iconBackgroundColor**: Background color behind icons
- **titleColor**: Primary text color
- **infoColor**: Secondary/info text color
- **chevronColor**: Navigation chevron color
- **tintColor**: General tint color for interactive elements
- **destructiveColor**: Color for destructive actions

## Icon Support

All setting components support SF Symbols through the `systemIcon` parameter:

```swift
ToggleSetting(
    "Dark Mode",
    systemIcon: "moon.fill",
    isOn: $darkModeEnabled
)

ButtonSetting(
    "Share",
    systemIcon: "square.and.arrow.up"
) {
    shareContent()
}
```

For custom icon views, use the generic icon parameter:

```swift
ToggleSetting(isOn: $isEnabled) {
    Image("custom-icon")
        .foregroundColor(.blue)
} label: {
    Text("Custom Feature")
}
```

## Advanced Usage

### Custom Setting Types

Create custom settings by conforming to `SettingPickable`:

```swift
enum AppTheme: String, SettingPickable, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var id: AppTheme { self }
    var description: String { rawValue }
}
```

### Conditional Settings

Use SwiftUI's conditional view rendering:

```swift
Form {
    Section("Notifications") {
        ToggleSetting("Enable Notifications", isOn: $notificationsEnabled)
        
        if notificationsEnabled {
            ToggleSetting("Sound", isOn: $soundEnabled)
            ToggleSetting("Badge", isOn: $badgeEnabled)
        }
    }
}
```

### Dynamic Content

Combine with SwiftUI's data flow:

```swift
ForEach(settingsCategories) { category in
    Section(category.title) {
        ForEach(category.settings) { setting in
            ToggleSetting(
                setting.title,
                systemIcon: setting.icon,
                isOn: binding(for: setting)
            )
        }
    }
}
```

## Requirements

- iOS 18.0+ / macOS 15.0+ / visionOS 2.0+ / tvOS 18.0+
- Swift 6.2+
- Xcode 16.0+

## License

SettingsUI is available under the BSD Zero Clause License. See the [LICENSE](LICENSE) file for more info.
