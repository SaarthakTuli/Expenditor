//
//  AddSheet.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 20/05/22.
//

import SwiftUI
import SwiftUIFontIcon



var icons: [Int: FontAwesomeCode] = [1: .car_alt, 2: .file_invoice_dollar, 3: .film, 4: .hand_holding_usd, 5: .hamburger, 6: .home, 7: .dollar_sign, 8: .shopping_cart, 9: .exchange_alt, 101: .bus, 102: .taxi, 201: .mobile_alt, 301: .film, 401: .hand_holding_usd, 402: .hand_holding_usd, 501: .shopping_basket, 502: .utensils, 601: .house_user, 602: .lightbulb, 701: .dollar_sign, 801: .icons, 901: .exchange_alt]


var titles: [Int: String] = [1: "Auto & Transport", 2: "Bills & Utiities", 3: "Entertainment", 4: "Fees & Charges", 5: "Food & Dining", 6: "Home", 7: "Income", 8: "Shopping", 9: "Transfer", 101: "Public Transportation", 102: "Taxi", 201: "Mobile Phone", 301: "Movies & DVD's", 401: "Bank Fee", 402: "Finance Charge", 501: "Groceries", 502: "Restaurant", 601: "Rent", 602: "Home Supplies", 701: "Paycheque", 801: "Software", 901: "Credit Card Payments"]

struct AddSheet: View {
    
    @Environment(\.presentationMode) var present
    
    @EnvironmentObject var databaseManager: DatabaseManager
    
    
    @State var name: String = ""
    @State var date: Date = Date()
    @State var institution: String = ""
    @State var account: String = ""
    @State var merchant: String = ""
    @State var amount: String = ""
    @State var type: String = ""
    @State var categoryId: Int = 0
    @State var category: String = ""
    
    @State var currency: String  = "INR"
    
    var body: some View {
        
        ZStack {
            Color.background.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack (spacing: 10) {
                    
                    // MARK: Name Field
                    VStack (alignment: .leading){
                        Text("Name")
                            .font(.title2)
                            .bold()
                        
                        TextField("Enter Name", text: $name)
                    }
                    .padding()
                    
                    // MARK: Date Field
                    VStack (alignment: .leading){
                        Text("Date: ")
                            .font(.title2)
                            .bold()
                        
                        DatePicker("", selection: $date)
                    }
                    .padding()
                    
                    // MARK: Institution Field
                    VStack (alignment: .leading){
                        Text("Institution: ")
                            .font(.title2)
                            .bold()
                        
                        TextField("Enter institution", text: $institution)
                    }
                    .padding()
                    
                    // MARK: Account Field
                    VStack (alignment: .leading){
                        Text("Account: ")
                            .font(.title2)
                            .bold()
                        
                        TextField("Enter Account", text: $account)
                    }
                    .padding()
                    
                    // MARK: Merchant Field
                    VStack (alignment: .leading){
                        Text("Merchant: ")
                            .font(.title2)
                            .bold()
                        
                        TextField("Enter Merchant", text: $merchant)
                        
                    }
                    .padding()
                    
                    // MARK: Amount Field
                    VStack (alignment: .leading){
                        Text("Amount: ")
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            
//                            Picker("Pick currency", selection: $currency) {
//                                ForEach(codeToCountry.keys.sorted().reversed(), id: \.self) { key in
//                                    Text(key).tag(key)
//
//                                }
//                            }
                            
                            TextField("Enter Amount", text: $amount)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .padding()
                    
                    // MARK: Type Field
                    VStack (alignment: .leading){
                        Text("Type: ")
                            .font(.title2)
                            .bold()
                        
                        Picker("Color Scheme", selection: $type) {
                            Text("Debit").tag("Debit")
    
                            Text("Credit").tag("Credit")
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    
                    // MARK: Category Field
                    VStack (alignment: .leading){
                        Text("Category: ")
                            .font(.title2)
                            .bold()
                        
                        Picker("", selection: $categoryId) {
                            ForEach(icons.keys.sorted(), id: \.self) { key in
                                
                                HStack {
                                    
                                    Text("\(titles[key]!)")
                                    
                                    Spacer()
                                    
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(Color.icon)
                                        .opacity(0.3)
                                        .frame(width: 44, height: 44)
                                        .overlay {
                                            FontIcon.text(.awesome5Solid(code: icons[key] ?? .bus), fontsize: 24, color: Color.icon)
                                        }
                                        .tag(key)
                                }
                            }
                        }
                        .pickerStyle(.wheel)
                        
                    }
                    .padding()
                    
                                            
                    }
                    
                    // MARK: Save Button
                    
                    Button(action: {
                        databaseManager.writeTransaction(transaction: Transaction(id: 1, date: "\(date.formatted(.dateTime.weekday().day().month().year().hour().minute()))", institution: institution, account: account, merchant: merchant, amount: Double(amount)?.roundedTo2Digits() ?? 0, type: type, categoryId: categoryId, category: "\(String(describing: titles[categoryId]))"))
                        
                        databaseManager.fetchTransactions()
                        
                        present.wrappedValue.dismiss()
                    }) {
                        
                        PrimaryButton(title: "Save")
      
                    }
            }
            
        }
        .navigationTitle(Text("Add New Transaction"))
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.systemBackground)
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct AddSheet_Previews: PreviewProvider {
    
    static let databaseManager : DatabaseManager = {
        let databaseManager = DatabaseManager()
        databaseManager.Transactions = transactionPreviewList
        return databaseManager
    }()
    
    static var previews: some View {
        Group {
           NavigationView {
                AddSheet()
           }
            NavigationView {
                AddSheet()
                    .preferredColorScheme(.dark)
            }
        }
        .environmentObject(databaseManager)
    }
}
