//
//  DatabaseManager.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 27/05/22.
//

import SwiftUI
import Firebase
import Combine
import Collections // MARK: to get ordered Dictionary...


typealias TransactionSorted = OrderedDictionary<String, [Transaction]>
typealias TransactionCummulativeSum = [(String, Double)]

class DatabaseManager: ObservableObject {
    @Published var Transactions = [Transaction]()
    
    //@Published var count = 0
    @AppStorage("TransactionNumber") var count = 0
    
    
    init() {
        fetchTransactions()
    }
    
    // MARK: Helper functions....
    // to get the cummulative transactions for the line chart.....
    func accumulateTransactions() -> TransactionCummulativeSum {
        
        guard !Transactions.isEmpty else { return [] }
        
        let today = "27/05/2022".dateParse() // CURRENT DATE...
        
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        
        var sum: Double = .zero
        var cummulativeSum = TransactionCummulativeSum()
        
        var dailyExpenses: [Transaction] = []
        
        for date in stride(from: dateInterval.start, to: today, by: 60*60*24) {
            
            
            Transactions.forEach({ transaction in
                if (transaction.date.removetime() ==  date.formatted(.dateTime.weekday().day().month().year())) {
                    dailyExpenses.append(transaction)
                    
                    let dailyToday = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
                    
                    sum += dailyToday
                    sum = sum.roundedTo2Digits()
                    cummulativeSum.append((date.formatted(), sum))
                    sum = 0
                }
            })
           
           // let dailyExpenses = Transactions.filter {_ in
//                $0.dateParsed.formatted(.dateTime.day().month().year()) == date.formatted(.dateTime.day().month().year())

            //} // && $0.isExpense
            
            
        }
        print(cummulativeSum)
        
        return cummulativeSum
        
    }
    
    
    
    // To sort the  transactions by month
    func groupTransactionsByMonth() -> TransactionSorted {
        guard !Transactions.isEmpty else { return [:] }
        
        let groupedTransactions = TransactionSorted(grouping: Transactions) { $0.month }
        
        return groupedTransactions
    }
    
    
    // MARK: Functions for database manipulatiion
    func fetchTransactions() {
        
        let db = Firestore.firestore()
        
        db.collection(Auth.auth().currentUser?.uid ?? "Transactions").getDocuments { snapshot, error in
            
            if error == nil {
                guard let snapshot = snapshot else { return }
                
                self.Transactions = snapshot.documents.compactMap({ (doc) -> Transaction? in
                    let id = doc.get("id") as? Int ?? 0
                    let date = doc.get("date") as? String ?? ""
                    let institution = doc.get("institution") as? String ?? ""
                    let account = doc.get("account") as? String ?? ""
                    let merchant = doc.get("merchant") as? String ?? ""
                    let amount = doc.get("amount") as? Double ?? 0.0
                    let type = doc.get("type") as? String ?? ""
                    let categoryId = doc.get("categoryId") as? Int ?? 0
                    let category = doc.get("category") as? String ?? ""
                    
                    return Transaction(id: id, date: date, institution: institution, account: account, merchant: merchant, amount: amount, type: type, categoryId: categoryId, category: category)
                })
            }
            
        }
        
        print("sucessfully fetched....")
    }
    
    
    func writeTransaction(transaction: Transaction) {
        
        let db = Firestore.firestore()
        
        db.collection(Auth.auth().currentUser?.uid ?? "").document("\(count)").setData(
            [
                "id": count,
                "date": transaction.date,
                "institution": transaction.institution,
                "account": transaction.account,
                "merchant": transaction.merchant,
                "amount": transaction.amount,
                "type": transaction.type,
                "categoryId": transaction.categoryId,
                "category": transaction.category
            ]) { (error) in
                if error != nil {
                    print("Error while writng data: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                self.count += 1
                print("transaction Successfully added...")
            }
        
    }
    
    
    func deleteTransaction(at offsets: IndexSet) {
        
        let db = Firestore.firestore()
        
        let str = "\(offsets)"
        let index = str.prefix(1)
        
        db.collection(Auth.auth().currentUser?.uid ?? "" ).document("\(index)").delete() {
            error in
            
            if let error = error {
                print("Error while deleting occured: \(error.localizedDescription)")
            }
            
            else {
                self.Transactions.remove(atOffsets: offsets)
                self.count -= 1
                
                print("The offst used is: \(index)")
                print("Sucesfully deleted..")
                print("No of transactions left are: \(self.count)")
            }
        }
    }
}



let codeToCountry = [
  "AED" : "United Arab Emirates",
  "AFN" : "Afghanistan",
  "ALL" : "Albania",
  "AMD" : "Armenia",
  "ANG" : "Netherlands Antilles",
  "AOA" : "Angola",
  "ARS" : "Argentina",
  "AUD" : "Australia, Australian Antarctic Territory, Christmas Island, Cocos (Keeling) Islands, Heard and McDonald Islands, Kiribati, Nauru, Norfolk Island, Tuvalu",
  "AWG" : "Aruba",
  "AZN" : "Azerbaijan",
  "BAM" : "Bosnia and Herzegovina",
  "BBD" : "Barbados",
  "BDT" : "Bangladesh",
  "BGN" : "Bulgaria",
  "BHD" : "Bahrain",
  "BIF" : "Burundi",
  "BMD" : "Bermuda",
  "BND" : "Brunei",
  "BOB" : "Bolivia",
  "BOV" : "Bolivia",
  "BRL" : "Brazil",
  "BSD" : "Bahamas",
  "BTN" : "Bhutan",
  "BWP" : "Botswana",
  "BYR" : "Belarus",
  "BZD" : "Belize",
  "CAD" : "Canada",
  "CDF" : "Democratic Republic of Congo",
  "CHE" : "Switzerland",
  "CHF" : "Switzerland, Liechtenstein",
  "CHW" : "Switzerland",
  "CLF" : "Chile",
  "CLP" : "Chile",
  "CNY" : "Mainland China",
  "COP" : "Colombia",
  "COU" : "Colombia",
  "CRC" : "Costa Rica",
  "CUP" : "Cuba",
  "CVE" : "Cape Verde",
  "CYP" : "Cyprus",
  "CZK" : "Czech Republic",
  "DJF" : "Djibouti",
  "DKK" : "Denmark, Faroe Islands, Greenland",
  "DOP" : "Dominican Republic",
  "DZD" : "Algeria",
  "EEK" : "Estonia",
  "EGP" : "Egypt",
  "ERN" : "Eritrea",
  "ETB" : "Ethiopia",
  "EUR" : "European Union, see eurozone",
  "FJD" : "Fiji",
  "FKP" : "Falkland Islands",
  "GBP" : "United Kingdom",
  "GEL" : "Georgia",
  "GHS" : "Ghana",
  "GIP" : "Gibraltar",
  "GMD" : "Gambia",
  "GNF" : "Guinea",
  "GTQ" : "Guatemala",
  "GYD" : "Guyana",
  "HKD" : "Hong Kong Special Administrative Region",
  "HNL" : "Honduras",
  "HRK" : "Croatia",
  "HTG" : "Haiti",
  "HUF" : "Hungary",
  "IDR" : "Indonesia",
  "ILS" : "Israel",
  "INR" : "Bhutan, India",
  "IQD" : "Iraq",
  "IRR" : "Iran",
  "ISK" : "Iceland",
  "JMD" : "Jamaica",
  "JOD" : "Jordan",
  "JPY" : "Japan",
  "KES" : "Kenya",
  "KGS" : "Kyrgyzstan",
  "KHR" : "Cambodia",
  "KMF" : "Comoros",
  "KPW" : "North Korea",
  "KRW" : "South Korea",
  "KWD" : "Kuwait",
  "KYD" : "Cayman Islands",
  "KZT" : "Kazakhstan",
  "LAK" : "Laos",
  "LBP" : "Lebanon",
  "LKR" : "Sri Lanka",
  "LRD" : "Liberia",
  "LSL" : "Lesotho",
  "LTL" : "Lithuania",
  "LVL" : "Latvia",
  "LYD" : "Libya",
  "MAD" : "Morocco, Western Sahara",
  "MDL" : "Moldova",
  "MGA" : "Madagascar",
  "MKD" : "Former Yugoslav Republic of Macedonia",
  "MMK" : "Myanmar",
  "MNT" : "Mongolia",
  "MOP" : "Macau Special Administrative Region",
  "MRO" : "Mauritania",
  "MTL" : "Malta",
  "MUR" : "Mauritius",
  "MVR" : "Maldives",
  "MWK" : "Malawi",
  "MXN" : "Mexico",
  "MXV" : "Mexico",
  "MYR" : "Malaysia",
  "MZN" : "Mozambique",
  "NAD" : "Namibia",
  "NGN" : "Nigeria",
  "NIO" : "Nicaragua",
  "NOK" : "Norway",
  "NPR" : "Nepal",
  "NZD" : "Cook Islands, New Zealand, Niue, Pitcairn, Tokelau",
  "OMR" : "Oman",
  "PAB" : "Panama",
  "PEN" : "Peru",
  "PGK" : "Papua New Guinea",
  "PHP" : "Philippines",
  "PKR" : "Pakistan",
  "PLN" : "Poland",
  "PYG" : "Paraguay",
  "QAR" : "Qatar",
  "RON" : "Romania",
  "RSD" : "Serbia",
  "RUB" : "Russia, Abkhazia, South Ossetia",
  "RWF" : "Rwanda",
  "SAR" : "Saudi Arabia",
  "SBD" : "Solomon Islands",
  "SCR" : "Seychelles",
  "SDG" : "Sudan",
  "SEK" : "Sweden",
  "SGD" : "Singapore",
  "SHP" : "Saint Helena",
  "SKK" : "Slovakia",
  "SLL" : "Sierra Leone",
  "SOS" : "Somalia",
  "SRD" : "Suriname",
  "STD" : "São Tomé and Príncipe",
  "SYP" : "Syria",
  "SZL" : "Swaziland",
  "THB" : "Thailand",
  "TJS" : "Tajikistan",
  "TMM" : "Turkmenistan",
  "TND" : "Tunisia",
  "TOP" : "Tonga",
  "TRY" : "Turkey",
  "TTD" : "Trinidad and Tobago",
  "TWD" : "Taiwan and other islands that are under the effective control of the Republic of China (ROC)",
  "TZS" : "Tanzania",
  "UAH" : "Ukraine",
  "UGX" : "Uganda",
  "USD" : "American Samoa, British Indian Ocean Territory, Ecuador, El Salvador, Guam, Haiti, Marshall Islands, Micronesia, Northern Mariana Islands, Palau, Panama, Puerto Rico, East Timor, Turks and Caicos Islands, United States, Virgin Islands",
  "USN" : "United States",
  "USS" : "United States",
  "UYU" : "Uruguay",
  "UZS" : "Uzbekistan",
  "VEB" : "Venezuela",
  "VND" : "Vietnam",
  "VUV" : "Vanuatu",
  "WST" : "Samoa",
  "XAF" : "Cameroon, Central African Republic, Congo, Chad, Equatorial Guinea, Gabon",
  "XAG" : "",
  "XAU" : "",
  "XBA" : "",
  "XBB" : "",
  "XBC" : "",
  "XBD" : "",
  "XCD" : "Anguilla, Antigua and Barbuda, Dominica, Grenada, Montserrat, Saint Kitts and Nevis, Saint Lucia, Saint Vincent and the Grenadines",
  "XDR" : "International Monetary Fund",
  "XFO" : "Bank for International Settlements",
  "XFU" : "International Union of Railways",
  "XOF" : "Benin, Burkina Faso, Côte d'Ivoire, Guinea-Bissau, Mali, Niger, Senegal, Togo",
  "XPD" : "",
  "XPF" : "French Polynesia, New Caledonia, Wallis and Futuna",
  "XPT" : "",
  "XTS" : "",
  "XXX" : "",
  "YER" : "Yemen",
  "ZAR" : "South Africa",
  "ZMK" : "Zambia",
  "ZWD" : "Zimbabwe"]

