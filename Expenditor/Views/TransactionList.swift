//
//  TransactionList.swift
//  Expenditor
//
//  Created by Saarthak Tuli on 29/12/22.
//

import SwiftUI
import CoreData
import SwiftUIFontIcon


struct TransactionList: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State var addLabel: Bool = false
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var transactions: FetchedResults<Transaction>
    
    @State private var searchText: String = ""
    @State private var update: Bool = false
    
    var body: some View {
        
            ZStack {
                Color.bg.ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(transactions) {trans in
                            
                            NavigationLink {
                                EditTransaction(transaction: trans)
                            } label: {
                                HStack(spacing: 20) {
                                    
                                    // MARK: Font icon
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(Color.icon)
                                        .opacity(0.3)
                                        .frame(width: 44, height: 44)
                                        .overlay {
                                            FontIcon.text(.awesome5Solid(code: CategoryDict[trans.category ?? "Transfer"]?.icon ?? .search_dollar))
                                        }
                                    
                                    
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        
                                        // MARK: Transactions Merchant...
                                        Text(trans.merchant ?? "Self")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                        
                                        // MARK: Transaction category
                                        Text(trans.category ?? "Transfer")
                                            .font(.footnote)
                                            .opacity(0.7)
                                            .lineLimit(1)
                                        
                                        // MARK: Transaction Date
                                        Text(trans.date?.formatToString() ?? Date.now.formatToString())
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()

                                    if trans.type == "debit" {
                                        Text("- ₹" + trans.amount.removeZerosFromEnd())
                                            .bold()
                                            .foregroundColor(Color.red.opacity(0.9))
                                    } else if trans.type == "credit" {
                                        Text("₹" + trans.amount.removeZerosFromEnd())
                                            .bold()
                                            .foregroundColor(Color.green.opacity(0.9))
                                    }
                                }
                                .padding([.top, .bottom], 8)
                                .listRowBackground(Color.clear)
                            }

                            
                        }
                        .onDelete(perform: removeExpense)
                        .listSectionSeparator(.hidden)
                        .background(Color.bg.ignoresSafeArea())
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(PlainListStyle())
           
                    
                }
                .navigationTitle("Transactions")
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // MARK: PLUS
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        NavigationLink {
                            AddTransaction()
                        } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.primary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
            }
        
    }
    
    private func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty { return nil }
        return NSPredicate(format: "%K BEGINSWITH[cd] %@ OR %K CONTAINS[cd] %@ OR %K BEGINSWITH[cd] %@ OR %K >= %@ OR %K BEGINSWITH[cd] %@", #keyPath(Transaction.merchant), query, #keyPath(Transaction.date), query, #keyPath(Transaction.category), query, #keyPath(Transaction.amount), query,
            #keyPath(Transaction.type), query)
    }
    
    func removeExpense(at offsets: IndexSet) {
        withAnimation {
            offsets.map {
                transactions[$0]
            }.forEach(managedObjContext.delete(_:))
            
            DataController().save(context: managedObjContext)
        }
    }
}


/*
 Trial for section and header style
 
 CODE:-
 
 ForEach(groupedData) { datum in
     Section {
         ForEach(datum.expense) { exp in
             NavigationLink {
                 EditExpense(id: exp.id!, merchant: exp.merchant!, amount: "\(exp.amount)", type: exp.type!, category: exp.category!, expense: exp)
             } label: {
                 RowExpenses(category: exp.category!, merchant: exp.merchant!, date: exp.date!, amount: exp.amount, type: exp.type!)
                     .padding()
             }
         }
         .onDelete(perform: removeExpense)

     } header: {
         Text(datum.month)
             .padding(.leading)
     }
 }
 .listSectionSeparator(.hidden)
 .background(Color.background.ignoresSafeArea())
 .listRowInsets(EdgeInsets())
 

 */


struct TransactionList_Previews: PreviewProvider {
    static var previews: some View {
        TransactionList()
    }
}
