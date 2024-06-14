//
//  LearnBundle.swift
//  Learn
//
//  Created by FunWidget on 2024/6/11.
//

import WidgetKit
import SwiftUI

@main
struct LearnBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 17.0, *) {
            Learn()
        }
        
        if #available(iOS 16.1, *) {
            LearnLiveActivity()
        }
    }
}
