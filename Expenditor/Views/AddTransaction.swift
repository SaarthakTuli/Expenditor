//
//  AddTransaction.swift
//  Expenditor
//
//  Created by Saarthak Tuli on 29/12/22.
//

import SwiftUI
import SwiftUIFontIcon
import CoreData

struct AddTransaction: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var id: String = ""
    @State private var suggestId: Bool = false
    @State private var newId: String = UUID().uuidString
    
    @State private var date: Date = Date()
    @State private var merchant: String = ""
    @State private var amount: String = ""
    @State private var type: String = "debit"
    @State private var category: String = "software"
    
    var body: some View {
            ZStack {
                
                Color.bg.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // MARK: Id of transaction
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("Transaction id: ")
                            
                            Text("*")
                                .font(.title)
                                .foregroundColor(.pink)
                                .opacity(id != "" ? 0 : 1)
                            
                            if suggestId {
                                VStack {
                                    Button {
                                        id = newId
                                    } label: {
                                        Text(newId.small())
                                            .padding(.vertical ,5)
                                            .padding(.horizontal)
                                            .foregroundColor(Color.text)
                                    }
                                }
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(15)
                                .clipShape(Capsule())
                                .padding(.leading)
                            }
                        }
                        .padding(.leading)
                        
                        TextField("Ex:- Grocery_0420", text: $id)
                            .keyboardType(.numberPad)
                            .padding()
                    }
                    .onChange(of: id) { _ in
                        if id != "" && id != newId { suggestId = true }
                        else { suggestId = false }
                    }
                    
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
                
            }
            .font(.title3)
            .foregroundColor(Color.primary)
            .background(Color.systemBackground.ignoresSafeArea())
            .navigationBarBackButtonHidden()
            .toolbar {
                // MARK: Cancel
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // MARK: Save
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if (id == "" || merchant == "" || amount == "") { return }
                            
                        DataController().addTransaction(id: id, merchant: merchant, type: type, date: date, category: category, amount: amount.extractDouble(), context: managedObjContext)
                        
                        dismiss()
                    }
                }
            }
            .navigationTitle( Text("Add Your Expense") )
    }
}


struct CategoryPicker: View {
    
    @State var title: String
    @State var icon: FontAwesomeCode
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.icon)
                .opacity(0.3)
                .frame(width: 44, height: 44)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: icon), fontsize: 24, color: Color.icon)
                }
                .padding()
            
            Text(title)
             
            Spacer(minLength: 0)
        }
        .padding(.vertical, 100)
    }
}

struct AddTransaction_Previews: PreviewProvider {
    static var previews: some View {
        AddTransaction()
    }
}
