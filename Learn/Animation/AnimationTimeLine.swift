//
//  AnimationTimeLine.swift
//  WidgetLearn
//
//  Created by FunWidget on 2024/6/20.
//

import SwiftUI
import WidgetKit
import AppIntents
import Intents

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct AnimationProvider: TimelineProvider {
    func placeholder(in context: Context) -> AnimationEntry {
        AnimationEntry(date: Date(), message: "\(NumberManager.number)")
    }
    func getSnapshot(in context: Context, completion: @escaping (AnimationEntry) -> Void) {
        let entry = AnimationEntry(date: Date(), message: "\(NumberManager.number)")
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<AnimationEntry>) -> Void) {
        
        let date = Date()
        var entries: [Entry] = []
        let entry = AnimationEntry(date: date , message: "\(NumberManager.number)")
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct AnimationEntry: TimelineEntry {
    let date: Date
    let message: String
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct AnimationEntryView : View {
    var entry: AnimationProvider.Entry
    var body: some View {
        VStack{

            Text(entry.message)
                .font(.title)
                .foregroundColor(Color.red)
                .padding(30)
                .background{
                    Color.yellow
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
//            ///闪现
//                .invalidatableContent()
//            ///iOS16可用 禁用动画
//                .contentTransition(.identity)
//            ///iOS16可用
//                .contentTransition(.opacity)
//                .contentTransition(.interpolate)
//                .contentTransition(.numericText(countsDown: false))
//            ///iOS17可用
//                .contentTransition(.numericText(value: Double(NumberManager.number)))
//            ///缩放 iOS17可用
//                .contentTransition(.symbolEffect)
//                .contentTransition(.symbolEffect(.automatic, options: .speed(1)))
//            ///转场动画：平移
//                .id(entry.message)
//                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
//                                        removal: .move(edge: .top).combined(with: .opacity)))
//                .animation(.easeInOut(duration: 0.3), value: entry.message)
//            ////3D旋转动画
                .rotation3DEffect(.degrees(entry.message == "1" ? 360 : 0), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
                .animation(Animation.smooth(duration: 2), value: entry.message)
            ///旋转动画
//                .rotationEffect(Angle(degrees: entry.message == "1" ? 360 : 0))
//                .animation(Animation.smooth(duration: 2), value: entry.message)
            
            ///摇摇乐动画
//            VStack{
//                Text(entry.message)
//                    .font(.title)
//                    .foregroundColor(Color.red)
//                    .padding(5)
//                    .padding(.vertical)
//                    .background {
//                        Color.yellow
//                    }
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                Spacer()
//                    .frame(height: 45)
//            }
//            .rotationEffect(entry.message == "1" ? .degrees(35) : .degrees(-35))
//            .animation(Animation.bouncy(duration: 2), value: entry.message)
            
            HStack{
                Button("button", intent: TestIntent(value: 1))
                Toggle("toggle", isOn: false, intent: TestIntent(value: -1))
            }
        }
        
    }
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct AnimationWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "AnimationWidget", provider: AnimationProvider()) { entry in
            AnimationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemSmall) {
    AnimationWidget()
} timeline: {
    AnimationEntry(date: .now, message: "1")
    AnimationEntry(date: .now, message: "0")
    AnimationEntry(date: .now, message: "1")
    AnimationEntry(date: .now, message: "0")
    AnimationEntry(date: .now, message: "1")
    AnimationEntry(date: .now, message: "0")
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
struct TestIntent: AppIntent {
    static var title: LocalizedStringResource = "Calculate Task"
    static var description: IntentDescription? = IntentDescription(stringLiteral: "Calculate Number Task")
    
    @Parameter(title: "value") var value: Int
    
    init() { }
    
    init(value: Int) {
        self.value = value
    }
    
    func perform() async throws -> some IntentResult {
        
        //等待5秒，模仿网络请求
        //        await withCheckedContinuation { c in
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        //                c.resume()
        //            }
        //        }
        NumberManager.number = value
        return .result()
    }
}

struct NumberManager {
    static var number = 0
}
