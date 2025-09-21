//
//  Copyright © 2025 Apparata AB. All rights reserved.
//


// MARK: - Mock Store

#if DEBUG
extension AppSettings {

    /// Creates a mock instance of `AppSettings` for use in previews and testing.
    ///
    /// The mock store is backed by an in-memory key–value store.
    ///
    /// - Returns: A mock `AppSettings` instance.
    ///
    public static func mock() -> AppSettings {
        let store = InMemoryKeyValueStore(keyedBy: Key.self, initialContent: [
            .colorScheme: AppColorScheme.system
        ])
        return AppSettings(store: store.eraseToAnyKeyValueStore())
    }
}
#endif
