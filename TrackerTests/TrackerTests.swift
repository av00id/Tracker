//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Сергей Андреев on 25.05.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
        func testTrackersViewControllerSnapshot() throws {
           
                let vc = TrackersViewController()
                assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
            }

            func testTrackersViewControllerDarkSnapshot() throws {
        
                let vc = TrackersViewController()
                assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
            }
    }

