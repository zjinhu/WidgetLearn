//
//  OldTimeline.swift
//  LearnExtension
//
//  Created by FunWidget on 2024/6/12.
//

import SwiftUI
import WidgetKit

struct OldProvider: TimelineProvider {
    func placeholder(in context: Context) -> OldSimpleEntry {
        OldSimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (OldSimpleEntry) -> Void) {
        let entry = OldSimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OldSimpleEntry>) -> Void) {

        // 调用回调方法把生成好的时间线数据传递给系统
        // policy 表示刷新策略
        // .atEnd 表示，所有的时间线条目完成之后重新刷新一次，表现就是这个getTimeline方法被回调一次
        // .after(date: Date) 表示，多久时间结束后再刷新一次
        // .never表示时间轴走完就不刷了
 
        var entries: [OldSimpleEntry] = []
        let currentDate = Date()

        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let entry = OldSimpleEntry(date: entryDate)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)

        completion(timeline)
    }
}

struct OldSimpleEntry: TimelineEntry {
    let date: Date
}

struct OldEntryView: View {
    var entry: OldProvider.Entry

    var body: some View {
        Text(Date().getCurrentDayStart(), style: .timer)
            .widgetBackground(Color.clear)
    }
}

extension Date {
   func getCurrentDayStart()-> Date {
       let calendar:Calendar = Calendar.current;
       let year = calendar.component(.year, from: self);
       let month = calendar.component(.month, from: self);
       let day = calendar.component(.day, from: self);

       let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
       return Calendar.current.date(from: components)!
   }
}


struct OldWidget: Widget {
    let kind: String = "LearnWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OldProvider()) { entry in
            OldEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

 
struct OldWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OldEntryView(entry: OldSimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            OldEntryView(entry: OldSimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            OldEntryView(entry: OldSimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

