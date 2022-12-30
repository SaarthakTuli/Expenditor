//
//  EditTransaction.swift
//  Expenditor
//
//  Created by Saarthak Tuli on 29/12/22.
//

//
//  EditExpense.swift
//  ExpenseTracker
//
//  Created by Saarthak Tuli on 16/12/22.
//

import SwiftUI

struct EditTransaction: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
        
    @State var id: String = UUID().uuidString
    @State var date: Date = Date.now
    @State var merchant: String = ""
    @State var amount: String = ""
    @State var type: String = "Credit"
    @State var category: String = "Transfer"
    
    var transaction: FetchedResults<Transaction>.Element
    
    @State var discardChanges: Bool = false
    
    var body: some View {
        ZStack {
            
            Color.bg.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("Edit Expense")
                    .padding(.top, -50)
                
                // MARK: Id of transaction
                HStack(spacing: 0) {
                    Text("Transaction id: \(id)")
                    
                    Spacer()
                }
                .padding(.leading)
                
                
                // MARK: Date
                DatePicker(selection: $date,in: ...Date.now,displayedComponents: .date, label: {
                    Text("Date")
                })
                .padding()
                
                // MARK: Merchant
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("Merchant Name: ")
                        
                        Text("*")
                            .font(.title)
                            .foregroundColor(.pink)
                            .opacity(merchant != "" ? 0 : 1)
                    }
                    .padding(.leading)
                    
                    TextField("Ex:- Apple, Grofers etc", text: $merchant)
                        .padding()
                }
                
                // MARK: Amount
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("Amount (in INR): ")
                        
                        Text("*")
                            .font(.title)
                            .foregroundColor(.pink)
                            .opacity(amount != "" ? 0 : 1)
                    }
                    .padding(.leading)
                    
                    TextField("Ex:- ₹10000", text: $amount)
                    .padding()
                    .keyboardType(.numberPad)
                }
                
                // MARK: Debit..Credit
                VStack(alignment: .leading, spacing: 5) {
                    Text("Type of transaction: ")
                    
                    Picker(selection: $type, label: Text(type)) {
                        Text("Debit")
                            .tag("debit")
                        
                        Text("Credit")
                            .tag("credit")
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                
                // MARK: Category
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("Category")
                        .padding(.leading)
                    
                    Picker(selection: $category, label: Text(category)) {
                        
                        CategoryPicker(title: "Auto & Transport", icon: .car_alt)
                            .tag("Auto & Transport")
                        
                        CategoryPicker(title: "Bills & Utiities", icon: .file_invoice_dollar)
                            .tag("Bills & Utiities")
                        
                        CategoryPicker(title: "Entertainment", icon: .film)
                            .tag("Entertainment")
                            
                        CategoryPicker(title: "Fees & Charges", icon: .hand_holding_usd)
                            .tag("Fees & Charges")
                        
                        CategoryPicker(title: "Food & Dining", icon: .hamburger)
                            .tag("Food & Dining")
                        
                        CategoryPicker(title: "Home", icon: .home)
                            .tag("Home")
                        
                        CategoryPicker(title: "Income", icon: .dollar_sign)
                            .tag("Income")
                        
                        CategoryPicker(title: "Shopping", icon: .shopping_cart)
                            .tag("Shopping")
                        
                        CategoryPicker(title: "Transfer", icon: .exchange_alt)
                            .tag("Transfer")
                        

                    }
                    .frame(height: 100)
                    .pickerStyle(.wheel)
                }
            }
            .padding(.top, -50)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    
                    DataController().editTransaction(transaction: transaction, merchant: merchant, type: type, date: date, category: category, amount: amount.extractDouble(), context: managedObjContext)

                    dismiss()
                }

            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    discardChanges.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                }

            }
        }
        .navigationBarBackButtonHidden()
        .confirmationDialog("Discard Changes", isPresented: $discardChanges) {
            VStack {
                Button("Yes, Discard") {
                    dismiss()
                }
                
                Button("Keep Editing") {
                    discardChanges.toggle()
                }
            }
        }
        .onAppear {
            id = transaction.id ?? UUID().uuidString
            date = transaction.date ?? Date.now
            merchant = transaction.merchant ?? ""
            amount = "\(transaction.amount)"
            type = transaction.type ?? "Credit"
            category = transaction.category ?? "Transfer"
        }
    }
}


//struct EditTransaction_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTransaction()
//    }
//}
