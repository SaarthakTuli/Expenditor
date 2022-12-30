//
//  Home.swift
//  Expenditor
//
//  Created by Saarthak Tuli on 29/12/22.
//

import SwiftUI
import Charts
import CoreData
import SwiftUIFontIcon

struct Item: Identifiable {
    var id = UUID()
    let date: String
    let amount: Double
}


typealias ExpenseSum = [(String, Double)]

struct Home: View {
    @Environment(\.managedObjectContext) var managedObjContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\.initialAmount)]) var main: FetchedResults<Main>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var transactions: FetchedResults<Transaction>
    @State var data: [Item] = [Item]()
    
    
    @State var initialAmount: String = "0.0"
    @State var accountAdded: Bool = false
    
    @State var moneyLeft: Double = 0.0
    @State var posAlt: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Title
                    Text("Overiew")
                        .font(.title2)
                        .bold()
                    
                    if accountAdded {
                        HStack(spacing: 24) {
                            Text("Money: ")
                                .font(.title)
                                .fontWeight(.heavy)
                            
                            Text("₹" + main[0].initialAmount.removeZerosFromEnd())
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .onTapGesture {
                            accountAdded = false
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text("Enter initial amount: ")
                            
                            TextField(text: $initialAmount) {
                                Text("Initial Amount is: ₹\(initialAmount)")
                            }
                            .onSubmit {
                                self.accountAdded = true
                                
                                if self.main.isEmpty {
                                    DataController().addMain(initialAmount: initialAmount.extractDouble(), context: managedObjContext)
                                } else {
                                    DataController().editMain(main: main[0], initialAmount: initialAmount.extractDouble(), context: managedObjContext)
                                }
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background(Color.bg)
                            .keyboardType(.decimalPad)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.primary, style: StrokeStyle(lineWidth: 1))
                            )
                        }
                    }
                    
                    // MARK: Chart
                    Chart(data) { data in
                        AreaMark(x: .value("Date", data.date),
                                 y: .value("Amount", data.amount))
                        .interpolationMethod(.linear)
                        .foregroundStyle(Color.text.gradient)
                        .foregroundStyle(by: .value("Date", "Amount"))
                        .accessibilityLabel(data.date)
                        .accessibilityValue("₹\(data.amount)")
                        
                        PointMark(x: .value("Date", data.date),
                                  y: .value("Amount", data.amount))
                        .foregroundStyle(Color.white.gradient)
                        .foregroundStyle(by: .value("Date", "Amount"))
                        .symbolSize(CGFloat(50))
                        
                        PointMark(x: .value("Date", data.date),
                                  y: .value("Amount", data.amount))
                        .foregroundStyle(Color.icon.gradient)
                        .foregroundStyle(by: .value("Date", "Amount"))
                        .symbolSize(CGFloat(30))
                        .annotation(position: posAlt == true ? .bottom : .top) {
                            Text("₹\(data.amount.removeZerosFromEnd().easyRead() )")
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                    .frame(height: 200)
                    .padding()
                    
                    // MARK: Transaction List
                    VStack {
                        // MARK: Header and Header Link
                        HStack {
                            Text("Recent Transactions")
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink {
                                TransactionList()
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
                        ForEach(Array(transactions.enumerated().prefix(5)), id: \.offset) { index, trans in
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
                            
                            Divider()
                                .opacity(index == 4 ? 0 : 1)
                        }
                        
                    }
                    .padding()
                }
                .padding([.bottom, .horizontal])
                .frame(maxWidth: .infinity)
                
            }
            .background(Color.bg.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // MARK: Notification Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
            }
        }
        
        .navigationViewStyle(.stack)
        .accentColor(.primary)
        .refreshable(action: {
            accumulateTransactions()
        })
        .onAppear {
            if self.main.isEmpty { accountAdded = false }
            else { accountAdded = true }
            
            accumulateTransactions()
        }
    }
    
    func accumulateTransactions() {
        initialAmount = "\(main[0].initialAmount)"
        
        if initialAmount == "0.0" { return }
        moneyLeft = Double(initialAmount)?.roundedTo2Digits() ?? 0.0
        data = [Item]()

        var dict = [String: Double]()

        for trans in transactions.reversed() {
            let date = trans.date?.formatToString() ?? Date.now.formatToString()

            if dict.keys.contains(date) {
                if trans.type == "debit" {
                    dict[date]! -= trans.amount
                    moneyLeft -= trans.amount
                } else if trans.type == "credit" {
                    dict[date]! += trans.amount
                    moneyLeft += trans.amount
                }
            } else {
                dict[date] = moneyLeft
                if trans.type == "debit" {
                    dict[date]! -= trans.amount
                    moneyLeft -= trans.amount
                } else if trans.type == "credit" {
                    dict[date]! += trans.amount
                    moneyLeft += trans.amount
                }
            }
            
            print("Dictionary is: ", dict)
        }

        let sortedDict = dict.sorted(by: { $0.0 < $1.0 })

        for n in sortedDict {
            data.append(Item(date: n.key, amount: n.value))
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
