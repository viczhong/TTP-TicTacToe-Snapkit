//
//  TicTacToe.swift
//  TTP-TicTacToe
//
//  Created by Victor Zhong on 4/21/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class TicTacToe {
    
    enum GridState {
        case empty
        case playerOne
        case playerTwo
    }
    
    var ticTacToeState = [[GridState]]() // to keep track of marks
    let rowAndColumnSize = 3
    
    init(){}
    
    func resetGameState() {
        // clears the matrix array and repopulates it with "empty" states
        ticTacToeState.removeAll()
        for _ in 0..<rowAndColumnSize {
            let row = Array(repeating: GridState.empty, count: rowAndColumnSize)
            ticTacToeState.append(row)
        }
    }
    
    func returnWinningPlayer() -> String? {
        var winnerName: String?
        let playerOneWinsString = "Player One Wins!"
        let playerTwoWinsString = "Player Two Wins!"
        
        // 1) 3 of the same marks in the same row
        if let rowWinner = checkRows() {
            if rowWinner == .playerOne {
                winnerName = playerOneWinsString
            } else {
                winnerName = playerTwoWinsString
            }
        }
        
        // 2) 3 of the same marks in the same column
        if let columnWinner = checkColumns() {
            if columnWinner == .playerOne {
                winnerName = playerOneWinsString
            } else {
                winnerName = playerTwoWinsString
            }
        }
        
        // 3) 3 of the same marks in diagonal
        if let diagonalWinner = checkDiagonals() {
            if diagonalWinner == .playerOne {
                winnerName = playerOneWinsString
            } else {
                winnerName = playerTwoWinsString
            }
        }
        
        return winnerName
    }
    
    fileprivate func checkGridStatesForWinner(_ arr: [GridState]) -> GridState? {
        // when this check is performed, it takes in 3 squares and sets them, so if there's a matching triplet, it'll only have 1 value
        let winnerArray = Array(Set(arr))
        
        // we don't ever want to return an "empty" state as the winner, so we check against that
        if winnerArray.count == 1 {
            if winnerArray.first != .empty {
                return winnerArray.first
            }
        }
        
        return nil
    }
    
    fileprivate func checkRows() -> GridState? {
        for row in 0..<rowAndColumnSize {
            var rowStates = [GridState]()
            
            for col in 0..<rowAndColumnSize {
                rowStates.append(ticTacToeState[row][col])
            }
            
            if let rowWinner = checkGridStatesForWinner(rowStates) {
                return rowWinner
            }
        }
        
        return nil
    }
    
    fileprivate func checkColumns() -> GridState? {
        for col in 0..<rowAndColumnSize {
            var colStates = [GridState]()
            
            for row in 0..<rowAndColumnSize {
                colStates.append(ticTacToeState[row][col])
            }
            
            if let colWinner = checkGridStatesForWinner(colStates) {            return colWinner
            }
        }
        
        return nil
    }
    
    fileprivate func checkDiagonals() -> GridState? {
        var fowardDiagonalState = [GridState]()
        var backWardDiagonalState = [GridState]()
        
        for row in 0..<rowAndColumnSize {
            for col in 0..<rowAndColumnSize {
                if row == col {
                    fowardDiagonalState.append(ticTacToeState[row][col])
                }
                
                if row + col == (rowAndColumnSize - 1) {
                    backWardDiagonalState.append(ticTacToeState[row][col])
                }
            }
        }
        
        if let forwardDiagonalWinner = checkGridStatesForWinner(fowardDiagonalState) {
            return forwardDiagonalWinner
        }
        
        if let backwardDiagonalWinner = checkGridStatesForWinner(backWardDiagonalState) {
            return backwardDiagonalWinner
        }
        
        return nil
    }
    
    func setMarkOn(_ position: (Int, Int), forPlayer: GridState) {
        ticTacToeState[position.0][position.1] = forPlayer
    }
    
    func convertStringToTupleFrom(_ title: String) -> (Int, Int) {
        let numbers = title.components(separatedBy: ",")
        let tuple = (Int(numbers[0])!, Int(numbers[1])!)
        
        return tuple
    }
    
    
}
