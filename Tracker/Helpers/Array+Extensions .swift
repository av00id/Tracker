//
//  Array+Extensions .swift
//  Tracker
//
//  Created by Сергей Андреев on 02.06.2023.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
