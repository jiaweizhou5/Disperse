//
//  GameState.swift
//  Disperse
//
//  Created by Tim Gegg-Harrison, Nicole Anderson on 12/20/13.
//  Copyright © 2013 TiNi Apps. All rights reserved.
//

import UIKit

class GameState {
    var board: [CardView]
    var blueTurn: Bool
    var blueScore: Int
    var redScore: Int
    var blueName: String
    var redName: String
    var cardsIndex: [Int]
//    var centerDic: [Int: CGPoint]
//    var removedCard: [Int: [Any]]
//    var removedCard = [Int: [((CardView), (CGFloat), (CGPoint))]]
    var removedCard: [Int: (card: CardView, rotation: CGFloat, center: CGPoint)]
    
    init() {
        board = [CardView]()
        blueTurn = true
        blueScore = 0
        redScore = 0
        blueName = ""
        redName = ""
        cardsIndex = [Int]()
        removedCard = [Int: (card: CardView, rotation: CGFloat, center: CGPoint)]()
    }
}

