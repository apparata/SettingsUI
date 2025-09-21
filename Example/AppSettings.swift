//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - AppSettings

/// A container for application-wide user settings.
///
/// `AppSettings` provides observable properties that represent user preferences
/// and persists them using an underlying key–value store.
/// It is designed to be injected into SwiftUI views and other components
/// that depend on reactive settings.
///
@Observable public final class AppSettings {

    // MARK: Key

    /// The keys used to store and retrieve settings from the underlying store.
    public enum Key: String {
        /// The preferred color scheme for the app.
        case colorScheme
    }

    // MARK: Properties

    /// The app's current color scheme preference.
    public var colorScheme: AppColorScheme {
        didSet {
            store.save(colorScheme, for: .colorScheme)
        }
    }

    // MARK: Setup

    /// The key–value store that backs this settings container.
    private let store: AnyKeyValueStore<AppSettings.Key>

    /// Creates a new instance of `AppSettings`.
    ///
    /// - Parameter store: The store used to persist values. If `nil`,
    ///   defaults to a `UserDefaults`-backed store.
    ///
    public init(store: AnyKeyValueStore<AppSettings.Key>? = nil) {
        self.store = store ?? .defaultStore
        colorScheme = self.store.load(.colorScheme, default: .system)
    }
}

// MARK: - Live Store

extension AnyKeyValueStore where Key == AppSettings.Key {
    /// The default live store for `AppSettings`, backed by `UserDefaults`.
    fileprivate static let defaultStore = UserDefaultsStore(
            keyedBy: Key.self,
            prefixedBy: "AppSettings"
        )
        .eraseToAnyKeyValueStore()
}
