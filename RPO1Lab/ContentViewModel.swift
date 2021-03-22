//
//  ContentViewModel.swift
//  RPO1Lab
//
//  Created by admin on 18.02.2021.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var cellColors = [[Color.gray, Color.gray, Color.gray], [Color.gray, Color.gray, Color.gray], [Color.gray, Color.gray, Color.gray]]
    
    @Published var currentColor: Color = Color.gray
    
    @Published var score = 0
    
    @Published var showAlert = false
    
    @Published var activeAlert: ActiveAlert = .gameOver
    
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
}
