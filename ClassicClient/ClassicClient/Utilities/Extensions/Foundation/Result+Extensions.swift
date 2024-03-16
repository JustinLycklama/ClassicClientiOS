//
//  Result+Extensions.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Foundation

extension Result {
    func mapVoid() -> Result<Void, Failure> {
        return self.map({ _ in () })
    }
}

extension Result where Success == Void {
    public static var success: Result { .success(()) }
}
