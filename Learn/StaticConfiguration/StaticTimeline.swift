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

        // 第一次刷新时间：延迟2秒刷
        let firstDate = OldProvider.getFirstEntryDate()
        // 第二次刷新时间：第一个整分钟时刷
        let firstMinuteDate = OldProvider.getFirstMinuteEntryDate()
        
        var entries: [OldSimpleEntry] = []
        entries.append(OldSimpleEntry(date: firstDate))
        entries.append(OldSimpleEntry(date: firstMinuteDate))
        
        // 后面以第一个整点分钟开始，每次加一分钟刷
        for minuteOffset in 1 ..< 60 {
            guard let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: firstMinuteDate) else {
                continue
            }
            entries.append(OldSimpleEntry(date: entryDate))
        }
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    static func getFirstEntryDate() -> Date {
        //设置刷新延迟几秒：延迟0秒刷
        let offsetSecond: TimeInterval = TimeInterval(0)
        var currentDate = Date()
        currentDate += offsetSecond
        return currentDate
    }

    // 获取第一个分钟时间点所处的时间点
    static func getFirstMinuteEntryDate() -> Date {
        var currentDate = Date()
        let passSecond = Calendar.current.component(.second, from: currentDate)
        let offsetSecond: TimeInterval = TimeInterval(60 - passSecond)
        currentDate += offsetSecond
        return currentDate
    }
}

struct OldSimpleEntry: TimelineEntry {
    let date: Date
}

struct OldEntryView: View {
    var entry: OldProvider.Entry

    var body: some View {
        Text(dateFormatter.string(from: entry.date))
            .frame(width: 56, height: 56)
            .widgetBackground(Color.clear)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
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

