//
//  LaunchAnimation.swift
//  Expenditor
//
//  Created by Saarthak Tuli on 30/12/22.
//


import SwiftUI
import SwiftUIFontIcon

struct LaunchAnimation: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @State private var rotate: Int  = 0
    @State private var inc: Int = 45
    
    @State private var scale = 1.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining: Int = 3
    
    @State var showHome: Bool = false
    
    var body: some View {
        if showHome {
            Home()
        }
        
        else  {
            ZStack {
                Color.bg.ignoresSafeArea()
    
                VStack(alignment: .center) {
                    ZStack {
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .film), fontsize: 44, color: Color.icon)
                                    .rotationEffect(Angle(degrees: -Double(rotate)))
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(rotate)))
                            .onAppear(perform: {
                                withAnimation(Animation.easeOut(duration: 5).repeatForever(autoreverses: false).speed(0.5)) {
                                         self.rotate = 360
                                     }
                                 })
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .hamburger), fontsize: 44, color: Color.icon)
                                    .rotationEffect(Angle(degrees: -Double(rotate + inc)))
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(rotate + inc)))
                            .onAppear(perform: {
                                withAnimation(Animation.easeOut(duration: 5).repeatForever(autoreverses: false).speed(0.5)) {
                                         self.rotate = 360
                                     }
                                 })
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .home), fontsize: 44, color: Color.icon)
                                    .rotationEffect(Angle(degrees: -Double(rotate + 2*inc)))
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(rotate + 2*inc)))
                            .onAppear(perform: {
                                withAnimation(Animation.easeOut(duration: 5).repeatForever(autoreverses: false).speed(0.5)) {
                                         self.rotate = 360
                                     }
                                 })
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .dollar_sign), fontsize: 44, color: Color.icon)
                                    .rotationEffect(Angle(degrees: -Double(rotate + 3*inc)))
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(rotate + 3*inc)))
                            .onAppear(perform: {
                                withAnimation(Animation.easeOut(duration: 5).repeatForever(autoreverses: false).speed(0.5)) {
                                         self.rotate = 360
                                     }
                                 })
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .shopping_basket), fontsize: 44, color: Color.icon)
                                    .rotationEffect(Angle(degrees: -Double(rotate + 4*inc)))
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(rotate + 4*inc)))
                            .onAppear(perform: {
                                withAnimation(Animation.easeOut(duration: 5).repeatForever(autoreverses: false).speed(0.5)) {
                                         self.rotate = 360
                                     }
                                 })
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .lightbulb), fontsize: 44, color: Color.icon)
                                    .rotationEffect(Angle(degrees: -Double(rotate + 5*inc)))
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(rotate + 5*inc)))
                            .onAppear(perform: {
                                withAnimation(Animation.easeOut(duration: 5).repeatForever(autoreverses: false).speed(0.5)) {
                                         self.rotate = 360
                                     }
                                 })
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .taxi), fontsize: 44, color: Color.icon)
                                    .rotationEffect(Angle(degrees: -Double(rotate + 6*inc)))
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(rotate + 6*inc)))
                            .onAppear(perform: {
                                withAnimation(Animation.easeOut(duration: 5).repeatForever(autoreverses: false).speed(0.5)) {
                                         self.rotate = 360
                                     }
                                 })
                        
                        Circle()
                            .fill(Color.icon)
                            .opacity(0.3)
                            .frame(width: 88, height: 88)
                            .overlay {
                                FontIcon.text(.awesome5Solid(code: .file_invoice), fontsize: 44, color: Color.icon)
                                    .rotationEffect(Angle(degrees: -Double(rotate + 7*inc)))
                            }
                            .offset(x: -125)
                            .rotationEffect(Angle(degrees: Double(rotate + 7*inc)))
                            .onAppear(perform: {
                                withAnimation(Animation.easeOut(duration: 5).repeatForever(autoreverses: false).speed(0.5)) {
                                         self.rotate = 360
                                     }
                                 })
                        
                    }
                }
                .scaleEffect(scale)
 
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0{
                    timeRemaining -= 1;
                } else {
                    withAnimation(.easeIn(duration: 0.7)) { scale = 10.0 }
                    withAnimation(.linear.delay(0.5)) { showHome = true }
                }
            }
        }
    }
}


struct LaunchAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAnimation()
    }
}
