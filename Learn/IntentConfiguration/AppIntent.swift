//
//  AppIntent.swift
//  Learn
//
//  Created by FunWidget on 2024/6/11.
//

import WidgetKit
import AppIntents
import Intents

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
extension ConfigurationAppIntent {
    static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
