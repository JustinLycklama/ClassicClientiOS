//
//  Axis.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

public enum Axis {
    case horizontal
    case vertical
}

public enum Alignment {
    case leading
    case trailing
    case center
}

public enum Edge: CaseIterable {
    case top
    case bottom
    case left
    case right
}

extension Array where Element == Edge {
    public static var all: [Edge] { [.top, .left, .right, .bottom] }
}
