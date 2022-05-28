//
//  Test.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 28/05/22.
//

import SwiftUI

struct Test: View {
    
    var testText: String? = "Hello"
    
    var body: some View {
        VStack {
            Text("The text is: ")
            
            Text(testText ?? "EXE")
            
            Button {
                print(self.testText ?? "hehe")
            } label: {
                Text("Click")
            }

        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
