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
        
        Task {
            let url = try? await DoggyFetcher.fetchRandomDoggy()
            
            let currentDate = Date()
            ///小于等于5分钟，五分后30秒内才会刷新，大概率5分22秒，大于五分钟都会在自定义时间后的40秒内刷新时间线
            let entry = NetworkSimpleEntry(date: currentDate, imageUrl: url)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
            
            let timeline = Timeline(
                entries: [entry],
                policy: .after(nextUpdate)
            )
            
            completion(timeline)
        }
    }
    
}

struct NetworkSimpleEntry: TimelineEntry {
    let date: Date
    var imageUrl: URL?
}

struct NetworkEntryView: View {
    var entry: NetworkProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
            if let imageUrl = entry.imageUrl{
                NetworkImage(url: imageUrl)
                Text(entry.date, style: .timer)
            }else{
                Text("Loading...")
                    .font(.headline)
            }
        }
        .widgetBackground(Color.clear)
    }
    
}

struct NetworkWidget: Widget {
    let kind: String = "NetworkWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NetworkProvider()) { entry in
            NetworkEntryView(entry: entry)
        }
        .configurationDisplayName("NetworkWidget")
        .description("This is an NetworkWidget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .onBackgroundURLSessionEvents { (sessionIdentifier, completion) in
            WidgetCenter.shared.reloadAllTimelines()
            completion()
        }
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemSmall) {
    NetworkWidget()
} timeline: {
    NetworkSimpleEntry(date: Date())
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemMedium) {
    NetworkWidget()
} timeline: {
    NetworkSimpleEntry(date: Date())
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 10.0, *)
#Preview(as: .systemLarge) {
    NetworkWidget()
} timeline: {
    NetworkSimpleEntry(date: Date())
}

struct NetworkImage: View {
    let url: URL?
    var body: some View {
        Group {
            if let url = url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                Text("Loading")
            }
        }
    }
}

struct Doggy: Decodable {
    let message: String
    let status: String
}

struct DoggyFetcher {
    
    static func fetchRandomDoggy() async throws -> URL? {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let doggy = try JSONDecoder().decode(Doggy.self, from: data)
        let result = URL(string: doggy.message)
        return result
    }
}
