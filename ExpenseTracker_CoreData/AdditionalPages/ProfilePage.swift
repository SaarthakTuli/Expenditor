//
//  ProfilePage.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 28/05/22.
//

import SwiftUI
import Firebase
import GoogleSignIn


struct ProfilePage: View {
    
    @Environment(\.presentationMode) var present
    
    @EnvironmentObject var databaseManager: DatabaseManager
    
    @AppStorage("log_Status") var log_Status = false
    
    @State var showingImagePicker = false
    @Binding var inputImage: UIImage?
    @State var image: Image = Image(systemName: "person.fill")
    
    var body: some View {
        VStack {
            
            ZStack {
                Button {
                    showingImagePicker.toggle()
                    
                } label: {
                    image
                        .resizable()
                        .frame(width: 130, height: 130)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                        .background(Color.systemBackground)
                        .clipShape(Circle())
                }

            }
            
            Text(Auth.auth().currentUser?.displayName ?? "User" )
                .font(.largeTitle)
                .foregroundColor(Color.primary)
                .bold()
            
            // MARK: logout button
            Button {
                googleLogOut()
                present.wrappedValue.dismiss()
                present.wrappedValue.dismiss()
            } label: {
                PrimaryButton(title: "Logout")
            }

                
            
            Spacer()
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Button  {
                    present.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }

            }
            
            ToolbarItem(placement: .principal ) {
                Text("Profile")
                    .font(.title)
                    .fontWeight(.semibold)
                    
            }
        
        }
        .accentColor(Color.primary)
        .onChange(of: inputImage) { _ in
            loadImage()
            store(image: inputImage!, forKey: "profile", withStorageType: .fileSystem)
        }
        .sheet(isPresented: $showingImagePicker) { ImagePicker(image: $inputImage) }
        
        .onAppear() {
            inputImage = retrieveImage(forKey: "profile", inStorageType: .fileSystem)
        }
        
    }
    
    func googleLogOut() {
        GIDSignIn.sharedInstance.signOut()
        try! Auth.auth().signOut()
        
        withAnimation {
            log_Status = false
        }
        
        print("Successfully logged out...")
       
    }
    
    
    // For profile Image...
    
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

//struct ProfilePage_Previews: PreviewProvider {
//
//    static let databaseManager : DatabaseManager = {
//        let databaseManager = DatabaseManager()
//        databaseManager.Transactions = transactionPreviewList
//        return databaseManager
//    }()
//
//    static var previews: some View {
//        Group {
//            NavigationView {
//                ProfilePage()
//
//            }
//
//            NavigationView {
//                ProfilePage()
//                    .preferredColorScheme(.dark)
//            }
//
//        }
//        .environmentObject(databaseManager)
//    }
//}
