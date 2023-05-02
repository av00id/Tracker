//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Сергей Андреев on 04.04.2023.
//

import UIKit

struct TrackerCategory {
    let id: UUID
    let label: String

    init(id: UUID = UUID(), label: String) {
        self.id = id
        self.label = label
    }
}
