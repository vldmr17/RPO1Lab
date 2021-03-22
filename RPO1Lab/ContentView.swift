//
//  ContentView.swift
//  RPO1Lab
//
//  Created by admin on 15.02.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView{
        VStack{
            HStack{
                Text("Score:").bold()
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 45).fill(Color.gray).frame(width: 40, height: 25)
                    Text(String(viewModel.score))
                }
            }.frame(width: 240)
            HStack{
                Text("Current Color:").bold()
                Spacer()
                RoundedRectangle(cornerRadius: 45).fill(viewModel.currentColor).frame(width: 40, height: 40).animation(.spring(), value: viewModel.currentColor)
            }.frame(width: 240)
            
            VStack{
                ForEach(0...2, id: \.self){i in
                    HStack{
                        ForEach(0...2, id: \.self){j in
                            RoundedRectangle(cornerRadius: 25).fill(viewModel.cellColors[i][j]).animation(.spring(), value: viewModel.cellColors[i][j]).frame(width: 80, height: 80).onTapGesture{
                                viewModel.tapHandler(i: i, j: j)
                            }
                        }
                    }
                }
            }
        }.onAppear(){
            viewModel.currentColor = viewModel.randomizeColor()
        }.alert(isPresented: $viewModel.showAlert){
            switch viewModel.activeAlert{
            case .gameOver:
                return Alert(title: Text("Game Over!"), message: Text("Your score: \(viewModel.score)"), dismissButton: .default(Text("Restart")){
                    for i in 0...2{
                        for j in 0...2{
                            viewModel.cellColors[i][j] = Color.gray
                        }
                    }
                    
                    viewModel.score = 0
                })
            case .restart:
                return Alert(title: Text("Restart?"), message: Text("Your game score (\(viewModel.score)) will be reset"), primaryButton: .destructive(Text("Restart")){
                    for i in 0...2{
                        for j in 0...2{
                            viewModel.cellColors[i][j] = Color.gray
                        }
                    }
                    
                    viewModel.score = 0
                }, secondaryButton: .cancel())
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Restart"){
                    viewModel.showAlert = true
                    viewModel.activeAlert = .restart
                }
            }
        }
        }
    }
}

enum ActiveAlert{
    case gameOver
    case restart
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
