//
//  TransactionListByMonth.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 20/05/22.
//

import SwiftUI

struct TransactionListByMonth: View {
    
    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        VStack {
            
            List {
                //ForEach(Array(transactionListVM.groupTransactionsByMonth()), id: \.key) { month, transactions in
                ForEach(Array(databaseManager.groupTransactionsByMonth()) , id: \.key) { month, transactions in
                    Section {
                        // MARK: List of transactions..
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                        .onDelete(perform: databaseManager.deleteTransaction)
                        
                    } header: {
                        // MARK: MONTH
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)

                    
                }
            }
            .listStyle(.plain)
            .refreshable {
                databaseManager.fetchTransactions()
            }
            
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct TransactionListByMonth_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView{
                TransactionListByMonth()
            }
            
            NavigationView {
                TransactionListByMonth()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
