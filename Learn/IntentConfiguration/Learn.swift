//
//  Learn.swift
//  Learn
//
//  Created by FunWidget on 2024/6/11.
//

import WidgetKit
import SwiftUI
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct LearnEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
        .widgetBackground(Color.clear)
    }
}

struct Learn: Widget {
    let kind: String = "Learn"

    var body: some WidgetConfiguration {
        makeWidgetConfiguration()
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
    }
    
    func makeWidgetConfiguration() -> some WidgetConfiguration {
        if #available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *) {
            return AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
                LearnEntryView(entry: entry)
            }
        } else {
            return IntentConfiguration(kind: kind, intent: IntentWidgetConfigurationIntent.self, provider: IntentProvider()) { entry in
                MyWidgetEntryView(entry: entry)
            }
        }
    }
}


@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemSmall) {
    Learn()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemMedium) {
    Learn()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemLarge) {
    Learn()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemExtraLarge) {
    Learn()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
