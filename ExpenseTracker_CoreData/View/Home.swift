//
//  Home.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 20/05/22.
//

import SwiftUI
import SwiftUICharts
import GoogleSignIn
import Firebase


struct Home: View {
    
    @Environment(\.presentationMode) var present
    
    @EnvironmentObject var databaseManager: DatabaseManager
    
    @State var inputImage: UIImage?
    @State var image: Image = Image(systemName: "person.fill")
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    // MARK: Chart
                    let data = databaseManager.accumulateTransactions()
                    
                    if !data.isEmpty {
                        let totalExpenses = data.last?.1 ?? 0
                        CardView {
                            VStack(alignment: .leading) {
                                ChartLabel("\(totalExpenses.formatted(.currency(code: "INR")) )", type: .title, format: "₹%.02f")
                                
                                        
                                LineChart()
                                
                            }
                            .background(Color.systemBackground)
                        }
                        .data(data)
                        .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                        .frame(height: 300)
                        
                    }
                    
                    
                    
                    // MARK: Transaction List
                    RecentTransaction()
                    
                    

                }
                .padding()
                .frame(maxWidth: .infinity)
                
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // MARK: Display Name
                ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarLeading ) {
                    
                    HStack {
                        
                        NavigationLink {
                            ProfilePage(inputImage: $inputImage)
                                .transition(AnyTransition.slide).animation(.default)
                        } label: {
                            image
                                .resizable()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.icon, .primary)
                                .frame(width: 44, height: 44)
                                .background(Color.systemBackground)
                                .clipShape(Circle())
                        }

                        
                        Text(Auth.auth().currentUser?.displayName ?? "User")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color.text)
                    }
                    
                }
                
                    // MARK: Notification Icon
                ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarTrailing ) {
                    HStack {
                        
                        Image(systemName: "bell.badge")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.icon, .primary)
        
                    
                        NavigationLink {
                            AddSheet()
                        } label: {
                            Image(systemName: "plus")
                                .symbolRenderingMode(.palette)
                        }
                    }
                }
            }
        }
        .onAppear() {
            databaseManager.fetchTransactions()
            inputImage = retrieveImage(forKey: "profile", inStorageType: .fileSystem)
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
        .onChange(of: inputImage) { _ in
            loadImage()
            store(image: inputImage!, forKey: "profile", withStorageType: .fileSystem)
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    
    enum StorageType {
        case userDefaults
        case fileSystem
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    private func store(image: UIImage,
                        forKey key: String,
                        withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation,
                                            forKey: key)
            }
        }
    }
    
    private func retrieveImage(forKey key: String,
                                inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
   
}

struct Home_Previews: PreviewProvider {
    
    static let databaseManager : DatabaseManager = {
        let databaseManager = DatabaseManager()
        databaseManager.Transactions = transactionPreviewList
        return databaseManager
    }()
    
    static var previews: some View {
        Group {
            Home()
                
            Home()
                .preferredColorScheme(.dark)
        }
        .environmentObject(databaseManager)
    }
}

