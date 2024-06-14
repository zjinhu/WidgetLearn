//
//  NetworkTimeline.swift
//  WidgetLearn
//
//  Created by FunWidget on 2024/6/14.
//

import SwiftUI
import WidgetKit

struct NetworkProvider: TimelineProvider {
    func placeholder(in context: Context) -> NetworkSimpleEntry {
        NetworkSimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (NetworkSimpleEntry) -> Void) {
        let entry = NetworkSimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NetworkSimpleEntry>) -> Void) {

        var entries: [NetworkSimpleEntry] = []
        let currentDate = Date()
        
        // 每 6 小时创建一个条目，持续 24 小时
        for hourOffset in 0..<24 where hourOffset % 6 == 0 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = NetworkSimpleEntry(date: entryDate)
            entries.append(entry)
        }

        // 创建时间线
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        completion(timeline)
    }
    
}

struct NetworkSimpleEntry: TimelineEntry {
    let date: Date
}

struct NetworkEntryView: View {
    var entry: NetworkProvider.Entry

    var body: some View {
        Text(entry.date, style: .timer)
            .frame(width: 56, height: 56)
            .widgetBackground(Color.clear)
    }
}

struct NetworkWidget: Widget {
    let kind: String = "LearnWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NetworkProvider()) { entry in
            NetworkEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

 
struct NetworkWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NetworkEntryView(entry: NetworkSimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            NetworkEntryView(entry: NetworkSimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            NetworkEntryView(entry: NetworkSimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

