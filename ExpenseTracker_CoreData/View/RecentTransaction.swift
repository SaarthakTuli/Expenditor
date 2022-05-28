//
//  RecentTransaction.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 20/05/22.
//

import SwiftUI

struct RecentTransaction: View {

    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        VStack {
            
            // MARK: Header and Header Link
            HStack {
                
                Text("Recent Transactions")
                    .bold()
                
                Spacer()
                
                NavigationLink {
                    TransactionListByMonth()
                } label: {
                    HStack(spacing: 4) {
                        Text("See All")
                        
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.text)
                }

            }
            .padding(.top)
            
            // MARK: Recent Transaction List
            
            //ForEach(Array(transactionListVM.transactions.prefix(5).enumerated()), id: \.element) { index, transaction in
            ForEach(Array(databaseManager.Transactions.prefix(5).enumerated()), id: \.element) { index, transaction in
                
                TransactionRow(transaction: transaction)
                
                Divider()
                    .opacity(index == 4 ? 0 : 1)
                
            }
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct RecentTransaction_Previews: PreviewProvider {
    static var previews: some View {
        RecentTransaction()
    }
}
