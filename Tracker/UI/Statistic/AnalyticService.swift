//
//  AnalyticService.swift
//  Tracker
//
//  Created by Сергей Андреев on 26.05.2023.
//
import Foundation
import YandexMobileMetrica

struct AnalyticService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: Key.api) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }

    func report(event: String, params: [AnyHashable: Any]) {
        print("\nEvent: ", event)
        print("Params: ", params, "\n")
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
