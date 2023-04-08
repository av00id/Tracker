//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Сергей Андреев on 04.04.2023.
//

import UIKit

struct TrackerCategory {
    let label: String
    let trackers: [Tracker]
}

extension TrackerCategory {
    static let sampleData: [TrackerCategory] = [
        TrackerCategory(label: "Домашний уют",
                        trackers: []),
        TrackerCategory(label: "Радостные мелочи", trackers: [])]
}
