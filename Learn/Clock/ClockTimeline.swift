//
//  ClockTimeline.swift
//  LearnExtension
//
//  Created by FunWidget on 2024/6/14.
//
import WidgetKit
import SwiftUI
import ClockHandRotationKit
import WidgetAnimationKit

struct ClockProvider: TimelineProvider {
    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> ()) {
        let entry = ClockEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> ()) {
        var entries: [ClockEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ClockEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ClockEntry: TimelineEntry {
    let date: Date
}

struct AnimateWidgetExtensionEntryView : View {
    var entry: ClockProvider.Entry
    let size: CGSize = CGSize(width: 75, height: 75)
    
    var body: some View {
        return VStack {
            Circle()
                .fill(Color.blue)
                .frame(
                    width: size.width,
                    height: size.height
                )
        }
        .widgetBackground(Color.clear)
//        .offset(x: 0, y: 0)
//        .clockHandRotationEffect(period: .custom(10), in: .current, anchor: .zero)
//        .offset(x: -(size.height / 3), y: 0)
//        .clockHandRotationEffect(period: .custom(10), in: .current, anchor: .zero)
        .swingAnimation(duration: 4, direction: .horizontal, distance: 280)
        .swingAnimation(duration: 1, direction: .vertical, distance: 60)
    }
}

struct ClockWidget: Widget {
    let kind: String = "ClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            AnimateWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemMedium) {
    ClockWidget()
} timeline: {
    ClockEntry(date: Date())
}
 
