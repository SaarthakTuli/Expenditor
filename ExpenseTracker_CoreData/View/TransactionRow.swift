//
//  TransactionRow.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 20/05/22.
//

import SwiftUI
import SwiftUIFontIcon

struct TransactionRow: View {
    
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 20) {
            
            // MARK: Font icon
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.icon)
                .opacity(0.3)
                .frame(width: 44, height: 44)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: transaction.icon), fontsize: 24, color: Color.icon)
                }
            
            
            
            VStack(alignment: .leading, spacing: 6) {
                
                // MARK: Transactions Merchant...
                Text(transaction.merchant)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                // MARK: Transaction category
                Text("\(transaction.category)".slice(from: "(", to: ")").slice(from: "\"", to: "\"") )
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                
                // MARK: Transaction Date
                HStack(spacing: 0) {
                    Text(transaction.date.split(separator: ",")[1] )
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text(",")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text(transaction.date.split(separator: ",")[2] )
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // MARK: Transactions Amount
            Text(transaction.signedAmount, format: .currency(code: "INR"))
                .bold()
                .foregroundColor(transaction.type == "Credit" ? Color.text : .primary)
        }
        .padding([.top, .bottom], 8)
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionRow(transaction: transactionPreviewData)
            TransactionRow(transaction: transactionPreviewData)
                .preferredColorScheme(.dark)
        }
    }
}

