//
//  ContentView.swift
//  firstBookCollector
//
//  Created by Райымбек Есетов on 03.04.2023.
//

import SwiftUI



struct WelcomePage: View {
    @State private var shouldShowDetail: Bool = false
    
    var body: some View {
        welcomePage.environmentObject(NavigationManager())

    }
    var welcomePage: some View {
        NavigationView {
            VStack {
                Group {
                    Image("image 8")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(alignment: .top)
                        .ignoresSafeArea()
                    Spacer()
                }
                Text("Save all interesting links in one app")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .foregroundColor(.white)
                    .font(.system(size: 35, weight: .bold, design: .default))
                Button(action: {shouldShowDetail.toggle()}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                        NavigationLink("Lets start collecting", destination: SecondPage(),
                                       isActive: $shouldShowDetail)
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .medium, design: .default))
                    }
                }
                
                .frame(width: 358, height: 58)
                .padding(.bottom, 50)
            }
            .background(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage().environmentObject(NavigationManager())
    }
}


