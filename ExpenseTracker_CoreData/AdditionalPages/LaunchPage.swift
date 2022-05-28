//
//  LaunchPage.swift
//  ExpenseTracker_CoreData
//
//  Created by Saarthak Tuli on 27/05/22.
//

import SwiftUI
import SwiftUIFontIcon
import Collections
import Firebase
import GoogleSignIn


struct LaunchPage: View {
    
    @State var isLoading: Bool = false
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining = 90
    
    @State var changer: Int = 0
    @State var inc: Int = 45
    @State var index: Int = 0
    
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        VStack {
            
            if log_Status {
                Home()
            }
            
            else {
                VStack(spacing: 200){
                    
                    // Circle Animation.......
                    ZStack {
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .film), fontsize: 44, color: Color.icon)
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(changer)))
                            .animation(
                                Animation
                                    .easeOut(duration: 5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.5)
                            )
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .hamburger), fontsize: 44, color: Color.icon)
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(changer + inc)))
                            .animation(
                                Animation
                                    .easeOut(duration: 5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.5)
                            )
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .home), fontsize: 44, color: Color.icon)
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(changer + 2*inc)))
                            .animation(
                                Animation
                                    .easeOut(duration: 5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.5)
                            )
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .dollar_sign), fontsize: 44, color: Color.icon)
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(changer + 3*inc)))
                            .animation(
                                Animation
                                    .easeOut(duration: 5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.5)
                            )
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .shopping_basket), fontsize: 44, color: Color.icon)
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(changer + 4*inc)))
                            .animation(
                                Animation
                                    .easeOut(duration: 5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.5)
                            )
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .lightbulb), fontsize: 44, color: Color.icon)
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(changer + 5*inc)))
                            .animation(
                                Animation
                                    .easeOut(duration: 5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.5)
                            )
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .taxi), fontsize: 44, color: Color.icon)
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(changer + 6*inc)))
                            .animation(
                                Animation
                                    .easeOut(duration: 5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.5)
                            )
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .file_invoice), fontsize: 44, color: Color.icon)
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(changer + 7*inc)))
                            .animation(
                                Animation
                                    .easeOut(duration: 5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.5)
                                )
                                
                                
                        }
                    
                    
                    VStack {
                        Text("Expendite")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                       
                        Button {
                            googleLogin()
                        } label: {
                            PrimaryButton(title: "Login")
                        }
                    }
                }
                .task {
                    changer += 360
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
            }
        }
    }
    
    func googleLogin(){
        
        // Google Sign In...
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading=true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {[self] user, error in
            if let error = error {
                isLoading=false
                print(error.localizedDescription)
               return
             }

             guard
               let authentication = user?.authentication,
               let idToken = authentication.idToken
                else {
                    isLoading=false
                    return
                }

             let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                            accessToken: authentication.accessToken)
            
            // Firebase Auth...
            Auth.auth().signIn(with: credential) { result, error in
                isLoading=false
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                // Display Username
                
                guard let user = result?.user else{return}
                
                print(user.displayName ?? "Success!")
                
                // Updating user as logged In...
                withAnimation {
                    log_Status = true
                }
            }
        }
    }
}

struct LaunchPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LaunchPage()
            LaunchPage()
                .preferredColorScheme(.dark)
        }
    }
}

struct PrimaryButton: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(Color.white)
            .font(.title)
            .fontWeight(.bold)
            .frame(width: UIScreen.main.bounds.width - 10, height: 70)
            .background(Color.text)
            .clipShape(Capsule())
    }
}
