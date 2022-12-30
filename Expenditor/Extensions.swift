//
//  Extensions.swift
//  Expenditor
//
//  Created by Saarthak Tuli on 29/12/22.
//

import Foundation
import SwiftUI

extension Color {
    static let bg = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension Date {
    func formatToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    func extractDouble() -> Double {
        return Double(self) ?? 0.0
    }
    
    func small() -> String {
        return String(self.prefix(7)) + "..." + String(self.suffix(7))
    }
    
    func easyRead() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let num = Double(formatter.number(from: self)!)
        
        let n = self.count - 4
        
        if (n < 4) {
            return self
        } else if (n >= 4 && n < 7) {
            return "\(((num)/1000).rounded())K"
        } else if (n >= 7 && n < 10) {
            return "\(((num)/1000000).rounded())M"
        } else if (n >= 10 && n < 13) {
            return "\(((num)/1000000000).rounded())B"
        } else {
            return self
        }
        return self
    }
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let number = NSNumber(value: self)
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        
        return String(formatter.string(from: number) ?? "")
    }
    
    func roundedTo2Digits() -> Double {
        return (self * 100).rounded() / 100
    }
}
