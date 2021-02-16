//
//  ContentView.swift
//  RPO1Lab
//
//  Created by admin on 15.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var cellColors = [[Color.gray, Color.gray, Color.gray], [Color.gray, Color.gray, Color.gray], [Color.gray, Color.gray, Color.gray]]
    
    @State private var currentColor: Color = Color.gray
    
    @State private var score = 0
    
    @State private var showAlert = false
    
    @State private var activeAlert: ActiveAlert = .gameOver
    
    func randomizeColor()-> Color{
        let colors = [Color.blue, Color.red, Color.green]
        
        return colors.randomElement()!
    }
    
    func tapHandler(i: Int, j: Int) {
        if(cellColors[i][j] == Color.gray){
            cellColors[i][j] = currentColor
            currentColor = randomizeColor()
        }
        
        var iCount = 0
        for k in 0...2{
            if(cellColors[i][j] == cellColors[i][k]){
                iCount += 1
            }
        }
        
        var jCount = 0
        for k in 0...2{
            if(cellColors[i][j] == cellColors[k][j]){
                jCount += 1
            }
        }
        
        if(iCount == 3 && jCount == 3){
            score += 5
            for k in 0...2{
                cellColors[i][k] = Color.gray
            }
            for k in 0...2{
                cellColors[k][j] = Color.gray
            }
        } else if (iCount == 3){
            score += 3
            for k in 0...2{
                cellColors[i][k] = Color.gray
            }
        } else if (jCount == 3){
            score += 3
            for k in 0...2{
                cellColors[k][j] = Color.gray
            }
        }
        
        var isGameOver = true
        gameOverLoop: for i in 0...2{
            for j in 0...2{
                if(cellColors[i][j] == Color.gray){
                    isGameOver = false
                    break gameOverLoop
                }
            }
        }
        
        if isGameOver {
            showAlert = true
            activeAlert = .gameOver
            
            
        }
        
    }
    
    var body: some View {
        NavigationView{
        VStack{
            HStack{
                Text("Score:").bold()
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 45).fill(Color.gray).frame(width: 40, height: 25)
                    Text(String(score))
                }
            }.frame(width: 240)
            HStack{
                Text("Current Color:").bold()
                Spacer()
                RoundedRectangle(cornerRadius: 45).fill(currentColor).frame(width: 40, height: 40).animation(.spring(), value: currentColor)
            }.frame(width: 240)
            HStack{
                ForEach(0...2, id: \.self){i in
                    RoundedRectangle(cornerRadius: 25).fill(cellColors[0][i]).animation(.spring(), value: cellColors[0][i]).frame(width: 80, height: 80).onTapGesture{
                        tapHandler(i: 0, j: i)
                    }
                }
            }
            HStack{
                ForEach(0...2, id: \.self){i in
                    RoundedRectangle(cornerRadius: 25).fill(cellColors[1][i]).animation(.spring(), value: cellColors[1][i]).frame(width: 80, height: 80).onTapGesture{
                        tapHandler(i: 1, j: i)
                    }
                }
            }
            HStack{
                ForEach(0...2, id: \.self){i in
                    RoundedRectangle(cornerRadius: 25).fill(cellColors[2][i]).animation(.spring(), value: cellColors[2][i]).frame(width: 80, height: 80).onTapGesture{
                        tapHandler(i: 2, j: i)
                    }
                }
            }
        }.onAppear(){
            currentColor = randomizeColor()
        }.alert(isPresented: $showAlert){
            switch activeAlert{
            case .gameOver:
                return Alert(title: Text("Game Over!"), message: Text("Your score: \(score)"), dismissButton: .default(Text("Restart")){
                    for i in 0...2{
                        for j in 0...2{
                            cellColors[i][j] = Color.gray
                        }
                    }
                    
                    score = 0
                })
            case .restart:
                return Alert(title: Text("Restart?"), message: Text("Your game score (\(score)) will be reset"), primaryButton: .destructive(Text("Restart")){
                    for i in 0...2{
                        for j in 0...2{
                            cellColors[i][j] = Color.gray
                        }
                    }
                    
                    score = 0
                }, secondaryButton: .cancel())
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Restart"){
                    showAlert = true
                    activeAlert = .restart
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
