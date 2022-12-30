//
//  DataController.swift
//  Expenditor
//
//  Created by Saarthak Tuli on 29/12/22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Transaction")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("ERROR: Unable to load Container...\(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data Saved")
        } catch {
            print("ERROR: Unable to save..")
        }
    }
    
    func addTransaction(id: String, merchant: String, type: String, date: Date, category: String, amount: Double, context: NSManagedObjectContext) {
        let transaction = Transaction(context: context)
        
        transaction.id = id
        transaction.merchant = merchant
        transaction.type = type
        transaction.date = date
        transaction.category = category
        transaction.amount = amount
        
        save(context: context)
    }
    
    func editTransaction(transaction: Transaction, merchant: String, type: String, date: Date, category: String, amount: Double, context: NSManagedObjectContext) {
        transaction.merchant = merchant
        transaction.type = type
        transaction.date = date
        transaction.category = category
        transaction.amount = amount
        
        save(context: context)
    }
    
    func addMain(initialAmount: Double, context: NSManagedObjectContext) {
        let main = Main(context: context)
        
        main.initialAmount = initialAmount
        
        save(context: context)
    }
    
    func editMain(main: Main, initialAmount: Double, context: NSManagedObjectContext) {
        main.initialAmount = initialAmount
        
        save(context: context)
    }
}
