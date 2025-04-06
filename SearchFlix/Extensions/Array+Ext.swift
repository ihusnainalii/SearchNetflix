//
//  Array+Ext.swift
//  SearchFlix
//
//  Created by Husnian Ali on 21.02.2025.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : self.first
    }
}

