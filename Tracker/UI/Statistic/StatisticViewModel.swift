//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Сергей Андреев on 03.06.2023.
//

final class StatisticViewModel {
    var onTrackerChange: (([TrackerRecord]) -> Void)?
    
    private let trackerRecordStore = TrackerRecordStore()
    private var trackers: [TrackerRecord] = [] {
        didSet {
            onTrackerChange?(trackers)
        }
    }
    
    func viewWillAppear() {
        guard let trackers = try? trackerRecordStore.loadCompletedTrackers() else { return }
        self.trackers = trackers
    }
}
