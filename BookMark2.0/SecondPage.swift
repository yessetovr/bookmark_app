//
//  SwiftUIView.swift
//  BookCollector
//
//  Created by Райымбек Есетов on 04.04.2023.
//

import SwiftUI

class NavigationManager: ObservableObject{
    @Published private(set) var dest: AnyView? = nil
    @Published var isActive: Bool = false

    func move(to: AnyView) {
        self.dest = to
        self.isActive = true
    }
}

struct SecondPage: View {
    @State private var showingSheet = false
    @State private var bookmarkTitle: String = ""
    @State private var bookmarkLink: String = ""
    @State private var shouldShowDetailSecond: Bool = false
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        bookMark.environmentObject(NavigationManager())
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
    
    var bookMark: some View {
        NavigationView {
            VStack {
                Text("Bookmark App")
                    .foregroundColor(.black)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .background()
                    .padding(.top, 10)
                Spacer()
                Text("Save your first \nbookmark")
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                Spacer()
                NavigationLink(destination: self.navigationManager.dest, isActive: self.$navigationManager.isActive) {
                    EmptyView()
                }
                Button(action: {self.showingSheet = true}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                            .frame(width: 358, height: 58, alignment: .bottom)
                            .ignoresSafeArea()
                        Text("Add bookmark")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium, design: .default))
                    }
                }
                .frame(width: 358, height: 58)
                .sheet(isPresented: $showingSheet) {
                    SheetView(showingSheet: $showingSheet).environmentObject(self.navigationManager)
                        .presentationDetents([.height(340)])
                        .presentationCornerRadius(20)
                }
            }
        }
    }
    
    struct SheetView: View {
        @Binding var showingSheet: Bool
        @State var dest: AnyView? = nil
        @State var nextPage = false
        @State var prompt = ""
        @State var link = ""
        @State var dataArray: [String] = []
        @State var linkArray: [String] = []
        @EnvironmentObject var navigationManager: NavigationManager
        
        var body: some View {
            NavigationView {
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {self.showingSheet = false}) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            Spacer()
                        }
                    }
                    
                    VStack {
                        
                        //title
                        Spacer()
                        HStack {
                            Text("Title")
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 358, height: 46)
                                .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.93))
                            TextField("Bookmark title", text: $prompt)
                                .frame(width: 325)
                        }
                        
                        //link
                        HStack {
                            Text("Link")
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 358, height: 46)
                                .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.93))
                            TextField("Bookmark link (URL)", text: $link)
                                .frame(width: 325)
                        }
                        
                        //button save
                        Spacer()
                        Button(action: {
                            saveText()
                            self.dest = AnyView(ContentView(dataArray: $dataArray, linkArray: $linkArray))
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black)
                                    .frame(width: 358, height: 58, alignment: .bottom)
                                    .ignoresSafeArea()
                                Text("Save")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium, design: .default))
                            }
                        }
                    }
                }
                .onDisappear {
                    // This code can run any where but I placed it in `.onDisappear` so you can see the animation
                    if let dest = self.dest {
                        self.navigationManager.move(to: dest)
                    }
                }
            }
        }
        func saveText() {
            dataArray.append(prompt)
            linkArray.append(link)
            print(dataArray)
            print(linkArray)
        }
    }
    
    
    
    struct ContentView: View {
        @Binding var dataArray: [String]
        @Binding var linkArray: [String]
        @State private var showingSheet2 = false
//        @State var prompt = ""
//        @State var link = ""
    //        let items = ["Google", "nFactorial School", "NY Times", "Bloomberg"]
        
        var body: some View {
            VStack {
                Text("List")
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .padding(.top, 10)
                Spacer()
                List {
                    //fix bug
                        ForEach(dataArray, id: \.self) { data in
                            ForEach(linkArray, id: \.self) { link in
                                HStack {
                                    Text(data)
                                    Spacer()
                                    Link(destination: URL(string: link)!) {
                                        Image(systemName: "link")
                                    }
                                }
                        }
                    }
                }
                .listStyle(.inset)
                Button(action: {self.showingSheet2 = true}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                            .frame(width: 358, height: 58, alignment: .bottom)
                            .ignoresSafeArea()
                        Text("Add bookmark")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium, design: .default))
                    }
                }
                .frame(width: 358, height: 58)
                .sheet(isPresented: $showingSheet2) {
                    SheetView2(showingSheet: $showingSheet2, dataArray: $dataArray, linkArray: $linkArray)
                        .presentationDetents([.height(340)])
                        .presentationCornerRadius(20)
                }
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        struct SheetView2: View {
            @Binding var showingSheet: Bool
            @State var dest: AnyView? = nil
            @State var nextPage = false
            @State var prompt = ""
            @State var link = ""
            @Binding var dataArray: [String]
            @Binding var linkArray: [String]
            @EnvironmentObject var navigationManager: NavigationManager
            
            var body: some View {
                NavigationView {
                    ZStack {
                        HStack {
                            Spacer()
                            VStack {
                                Button(action: {self.showingSheet = false}) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.black)
                                        .padding()
                                }
                                Spacer()
                            }
                        }
                        
                        VStack {
                            
                            //title
                            Spacer()
                            HStack {
                                Text("Title")
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 358, height: 46)
                                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.93))
                                TextField("Bookmark title", text: $prompt)
                                    .frame(width: 325)
                            }
                            
                            //link
                            HStack {
                                Text("Link")
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 358, height: 46)
                                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.93))
                                TextField("Bookmark link (URL)", text: $link)
                                    .frame(width: 325)
                            }
                            
                            //button save
                            Spacer()
                            Button(action: {
                                saveText()
        //                        self.dest = AnyView(ContentView(dataArray: $dataArray))
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.black)
                                        .frame(width: 358, height: 58, alignment: .bottom)
                                        .ignoresSafeArea()
                                    Text("Save")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium, design: .default))
                                }
                            }
                        }
                    }
                }
            }
            func saveText() {
                dataArray.append(prompt)
                linkArray.append(prompt)
                print(dataArray)
            }
        }

    }
}






    
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SecondPage().environmentObject(NavigationManager())
        }
    }
}
