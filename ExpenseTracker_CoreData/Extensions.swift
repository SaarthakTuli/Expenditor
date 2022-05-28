//
//  Extensions.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 20/05/22.
//

import SwiftUI
import Foundation

extension Color {
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter {
    static let allNumeric: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParse() -> Date {
        guard let parseDate = DateFormatter.allNumeric.date(from: self)
        else {return Date()}
        
        return parseDate
    }
    
    func slice(from: String, to: String) -> String {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }!
    }
    
    func removetime() -> String {
        return "\(self.split(separator: ",")[0]),\(self.split(separator: ",")[1]),\(self.split(separator: ",")[2])"
    }
    
}

extension Date: Strideable {
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
}

extension Double {
    func roundedTo2Digits() -> Double {
        return (self * 100).rounded() / 100
    }
}

extension View {    
    // Retrieving RootView Controller
    func getRootViewController()-> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else {return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        
        return root
        
    }
    
}

