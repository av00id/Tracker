//
//  Strings+Generated.swift
//  Tracker
//
//  Created by Сергей Андреев on 07.06.2023.
//
//так и не разобрался до конца со свифтгеном, поэтому просто позаимствовал нужный код вручную
import Foundation

internal enum L10n {
    
    internal static let day = L10n.tr("Localizible", "day", fallback: "день")
    
    internal static let filters = L10n.tr("Localizable", "filters", fallback: "Фильтры")
    
    internal static func numberOfDays(_ p1: Int) -> String {
        return L10n.tr("Localizable", "numberOfDays", p1, fallback: "Plural format key: \"%#@days@\"")
    }
    internal enum Main {
        
        internal static let title = L10n.tr("Localizable", "main.title", fallback: "Трекеры")
    }
    
    internal enum Statistics {
        
        internal static let title = L10n.tr("Localizable", "statistics.title", fallback: "Статистика")
    }
    internal enum Tabbar {
        
        internal static let statistics = L10n.tr("Localizable", "tabbar.statistics", fallback: "Статистика")
        
        internal static let trackers = L10n.tr("Localizable", "tabbar.trackers", fallback: "Трекеры")
    }
}

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {
    static let bundle: Bundle = {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: BundleToken.self)
#endif
    }()
}

