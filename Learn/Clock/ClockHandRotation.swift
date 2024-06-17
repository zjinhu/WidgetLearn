//
//  Xcode13ClockHandRotationEffectModifier.swift
//  Xcode13ClockHandRotationEffectModifier
//
//  Created by everettjf on 2022/12/14.
//
import SwiftUI
import WidgetKit
import ClockHandRotationKit
public enum Direction: Hashable, Equatable {
    case horizontal
    case vertical
}

public extension View {
    func swingAnimation(duration: CGFloat, direction: Direction = .horizontal, distance: CGFloat) -> some View {
        modifier(SwingAnimationModifier(duration: duration, direction: direction, distance: distance))
    }
}

public struct SwingAnimationModifier: ViewModifier {
    /// The duration of the animation.
    public let duration: CGFloat

    /// The direction of the swing animation.
    public let direction: Direction

    /// The distance of the swing animation.
    public let distance: CGFloat

    /// Creates a swing animation modifier with the specified duration, direction, and distance.
    /// - Parameters:
    ///   - duration: The duration of the animation.
    ///   - direction: The direction of the swing animation.
    ///   - distance: The distance of the swing animation.
    public init(duration: CGFloat, direction: Direction, distance: CGFloat) {
        self.duration = duration
        self.direction = direction
        self.distance = distance
    }

    private var alignment: Alignment {
        if direction == .vertical {
            return distance > 0 ? .top : .bottom
        } else {
            return distance > 0 ? .leading : .trailing
        }
    }

    @ViewBuilder
    private func overlayView(content: Content) -> some View {
        let alignment = alignment
        GeometryReader {
            let size = $0.size
            let extendLength = direction == .vertical ? size.height : size.width
            let length: CGFloat = abs(distance) + extendLength
            let innerDiameter = (length + extendLength) / 2
            let outerAlignment: Alignment = {
                if direction == .vertical {
                    return distance > 0 ? .bottom : .top
                } else {
                    return distance > 0 ? .trailing : .leading
                }
            }()

            ZStack(alignment: outerAlignment) {
                Color.clear
                ZStack(alignment: alignment) {
                    Color.clear
                    ZStack(alignment: alignment) {
                        Color.clear
                        content.clockHandRotationEffect(period: .custom(duration))
                    }
                    .frame(width: innerDiameter, height: innerDiameter)
                    .clockHandRotationEffect(period: .custom(-duration / 2))
                }
                .frame(width: length, height: length)
                .clockHandRotationEffect(period: .custom(duration))
            }
            .frame(width: size.width, height: size.height, alignment: alignment)
        }
    }

    public func body(content: Content) -> some View {
        content.hidden()
            .overlay(overlayView(content: content))
    }
}

/**
 
@available(iOS 14.0, *)
public enum ClockHandRotationPeriod {
    case custom(TimeInterval)
    case secondHand, hourHand, minuteHand
}
///这些私有方法只有Xcode13提供
@available(iOS 14.0, *)
public struct ClockHandRotationModifier : ViewModifier {
    
    let clockPeriod: WidgetKit._ClockHandRotationEffect.Period
    let clockTimezone: TimeZone
    let clockAnchor: UnitPoint
    
    public init(period: ClockHandRotationPeriod, timezone: TimeZone = .current, anchor: UnitPoint = .center) {
        var clockPeriod: WidgetKit._ClockHandRotationEffect.Period = .secondHand
        switch period {
        case .custom(let timeInterval):
            clockPeriod = .custom(timeInterval)
        case .secondHand:
            clockPeriod = .secondHand
        case .hourHand:
            clockPeriod = .hourHand
        case .minuteHand:
            clockPeriod = .minuteHand
        }
        self.clockPeriod = clockPeriod
        self.clockTimezone = timezone
        self.clockAnchor = anchor
    }
    
    public func body(content: Content) -> some View {
        content
            ._clockHandRotationEffect(self.clockPeriod, in: self.clockTimezone, anchor: self.clockAnchor)
    }
    
}

@available(iOS 14.0, *)
extension View {
    
    public func clockHandRotationEffect(period : ClockHandRotationPeriod, in timeZone: TimeZone = .current, anchor: UnitPoint = .center) -> some View {
        return modifier(ClockHandRotationModifier(period: period, timezone: timeZone, anchor: anchor))
    }
}
 
 */
