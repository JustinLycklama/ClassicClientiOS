//
//  LoadingState.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-03-15.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import Combine

class LoadingState {
    
    var onChange: ((Bool) -> Void)?
    
    private var counter = 0 {
        didSet {
            isLoading = counter > 0
        }
    }
    
    @Published private(set) var isLoading = false {
        didSet {
            if oldValue != isLoading {
                onChange?(isLoading)
            }
        }
    }
    
    func set(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func increment() {
        counter += 1
    }
    
    func decrement() {
        counter -= 1
    }
}
