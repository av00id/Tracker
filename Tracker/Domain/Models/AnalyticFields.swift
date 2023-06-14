//
//  AnalyticFields.swift
//  Tracker
//
//  Created by Сергей Андреев on 26.05.2023.
//

import Foundation

struct Key {
 static let api = "fdf2c077-d7d1-4142-b930-7f29f15f24eb"
}

struct AnalyticEventNames {
    static let open = "open"
    static let close = "close"
    static let click = "click"
}

struct AnalyticScreenNames {
    static let trackers = "Main"
}

struct AnalyticItemNames {
    static let none = ""
    static let addTrack = "add_track"
    static let completeTrack = "track"
    static let filter = "filter"
    static let edit = "edit"
    static let delete = "delete"
}
