//
//  PreviewData.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 20/05/22.
//

import SwiftUI
import Foundation

var transactionPreviewData = Transaction(id: 1, date: "23/08/2022", institution: "Desjardins", account: "Visa", merchant: "Apple", amount: 11.49, type: "debit", categoryId: 801, category: "software")


var transactionPreviewList = [Transaction](repeating: transactionPreviewData, count: 10)
