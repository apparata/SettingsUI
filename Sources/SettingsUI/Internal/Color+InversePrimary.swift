//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

extension Color {
    /// Cross-platform dynamic inverse of .primary: white in light mode, black in dark mode.
    internal static var inversePrimary: Color {
        #if os(macOS)
        // NSColor dynamic provider for macOS
        let dynamic = NSColor(name: nil) { appearance in
            // Resolve an NSAppearanceName to determine dark vs light
            if appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
                return NSColor.black
            } else {
                return NSColor.white
            }
        }
        return Color(dynamic)
        #else
        // UIColor dynamic provider for iOS/iPadOS/tvOS/visionOS
        return Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        })
        #endif
    }
}
