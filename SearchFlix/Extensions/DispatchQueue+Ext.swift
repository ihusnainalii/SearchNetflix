//
//  DispatchQueue+Ext.swift
//  SearchFlix
//
//  Created by Husnian Ali on 26.02.2025.
//

import Foundation

extension DispatchQueue {
    static func performOnMainThread(_ action: @escaping () -> Void) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
    }
}

