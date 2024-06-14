//
//  LearnLiveActivity.swift
//  Learn
//
//  Created by FunWidget on 2024/6/11.
//

import ActivityKit
import WidgetKit
import SwiftUI
@available(iOS 16.1, *)
struct LearnAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
@available(iOS 16.1, *)
struct LearnLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LearnAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
@available(iOS 16.1, *)
extension LearnAttributes {
    fileprivate static var preview: LearnAttributes {
        LearnAttributes(name: "World")
    }
}
@available(iOS 16.1, *)
extension LearnAttributes.ContentState {
    fileprivate static var smiley: LearnAttributes.ContentState {
        LearnAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LearnAttributes.ContentState {
         LearnAttributes.ContentState(emoji: "🤩")
     }
}
@available(iOS 17.0, *)
#Preview("Notification", as: .content, using: LearnAttributes.preview) {
   LearnLiveActivity()
} contentStates: {
    LearnAttributes.ContentState.smiley
    LearnAttributes.ContentState.starEyes
}
