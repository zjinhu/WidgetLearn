//
//  SwiftUIView.swift
//  LearnExtension
//
//  Created by FunWidget on 2024/6/12.
//

import SwiftUI
import Intents
import WidgetKit

///创建可配置小组件需要创建新的Target 〉Intents Extension 不带 Intents UI
///然后在他内部创建SiriKit Intent文件
///按步骤在Intent内new Intents enums types
///参考：https://medium.com/@deisycmelo/how-to-add-siri-shortcut-actions-in-your-app-5c8d812b11f1
struct IntentSimpleEntry: TimelineEntry {
    let date: Date
    let configuration: IntentWidgetConfigurationIntent
}

struct IntentProvider: IntentTimelineProvider {

    func placeholder(in context: Context) -> IntentSimpleEntry {
        IntentSimpleEntry(date: Date(), configuration: IntentWidgetConfigurationIntent())
    }

    func getSnapshot(for configuration: IntentWidgetConfigurationIntent, in context: Context, completion: @escaping (IntentSimpleEntry) -> Void) {
        let entry = IntentSimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: IntentWidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<IntentSimpleEntry>) -> Void) {
        var entries: [IntentSimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = IntentSimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MyWidgetEntryView : View {
    var entry: IntentProvider.Entry

    var body: some View {
        ZStack {
            Color.yellow // 设置背景颜色
            VStack {
                Text(entry.date, style: .time)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .widgetBackground(Color.clear)
    }
}

//struct MyWidget: Widget {
//    let kind: String = "MyWidget"
//
//    var body: some WidgetConfiguration {
//        IntentConfiguration(kind: kind, intent: IntentWidgetConfigurationIntent.self, provider: IntentProvider()) { entry in
//            MyWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
//    }
//}
//
//struct MyWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            MyWidgetEntryView(entry: IntentSimpleEntry(date: Date(), configuration: IntentWidgetConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//            MyWidgetEntryView(entry: IntentSimpleEntry(date: Date(), configuration: IntentWidgetConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .systemMedium))
//            MyWidgetEntryView(entry: IntentSimpleEntry(date: Date(), configuration: IntentWidgetConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//            MyWidgetEntryView(entry: IntentSimpleEntry(date: Date(), configuration: IntentWidgetConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
//        }
//    }
//}
