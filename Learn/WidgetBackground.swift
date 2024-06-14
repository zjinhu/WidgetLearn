//
//  WidgetBackground.swift
//  WidgetLearn
//
//  Created by FunWidget on 2024/6/14.
//

import SwiftUI
import WidgetKit

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
