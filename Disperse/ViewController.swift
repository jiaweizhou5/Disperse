 //
 //  ViewController.swift
 //  Disperse
 //
 //  Created by Tim Gegg-Harrison, Nicole Anderson, Jiawei Zhou on 1/20/19.
 //  Copyright © 2013 TiNi Apps. All rights reserved.
 //
 
 import UIKit
 
 let CARDWIDTH: CGFloat = UIScreen.main.bounds.size.width / 4.0
 let CARDHEIGHT: CGFloat = 214.0 * CARDWIDTH / 150.0
 
 
 class ViewController: UIViewController {
    
    private let MAXCARDS: Int = 10
    private let BLUE: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.609375, alpha: 1.0)
    private let RED: UIColor = UIColor(red: 0.733333, green: 0.0, blue: 0.0, alpha: 1.0)

    private let playButton: UIButton
    private let exitButton: UIButton
    private let replayButton: UIButton

    private let scoreLabel: UILabel = UILabel()
    private var blueScore: Int
    private var redScore: Int
    private var blueName: String
    private var redName: String

    private var cardsIndex: [Int]
//    private var centerDic: [Int: CGPoint]
    private var removedCard: [Int: (card: CardView, rotation: CGFloat, center: CGPoint)]
//    private var removedCard: [Int: [((CardView), (CGFloat), (CGPoint))]]
//    private var removedCard: [Int: [Any]]
    
    private var replayHasBeenPressed: Bool

    private let game: GameState
    private var spades: Bool
    private var hearts: Bool
    private var diamonds: Bool
    private var clubs: Bool
    
    let clubsImage: UIImageView = UIImageView()
    let diamondsImage: UIImageView = UIImageView()
    let heartsImage: UIImageView = UIImageView()
    let spadesImage: UIImageView = UIImageView()
    
    var blueStart: Bool = false
    var redStart: Bool = false
    
    let blueAlert: UIAlertController = UIAlertController()
    let redAlert: UIAlertController = UIAlertController()
    
    init() {
//    override func viewDidLoad() {
//        super.viewDidLoad()
        
        let CONTROLSIZE: CGFloat = UIScreen.main.bounds.size.width / 10.0
        let CONTROLSPACE: CGFloat = (UIScreen.main.bounds.size.width - (5.0 * CONTROLSIZE)) / 6.0
        let CONTROLLEFTOFFSET: CGFloat = (2.0 * CONTROLSPACE) + CONTROLSIZE
        let CONTROLTOPOFFSET: CGFloat = UIScreen.main.bounds.size.height - 3.0 * CONTROLSIZE
        
        clubsImage.frame = CGRect(x: (CONTROLSPACE+CONTROLSIZE)*1, y: 2*CONTROLSIZE, width: CONTROLSIZE, height: CONTROLSIZE)
        clubsImage.image = UIImage(named: "club.png")
        
        diamondsImage.frame = CGRect(x: (CONTROLSPACE+CONTROLSIZE)*2, y: 2*CONTROLSIZE, width: CONTROLSIZE, height: CONTROLSIZE)
        diamondsImage.image = UIImage(named: "diamond")
        
        heartsImage.frame = CGRect(x: (CONTROLSPACE+CONTROLSIZE)*3, y: 2*CONTROLSIZE, width: CONTROLSIZE, height: CONTROLSIZE)
        heartsImage.image = UIImage(named: "heart")
        
        spadesImage.frame = CGRect(x: (CONTROLSPACE+CONTROLSIZE)*4, y: 2*CONTROLSIZE, width: CONTROLSIZE, height: CONTROLSIZE)
        spadesImage.image = UIImage(named: "spade")
        
        spades = true
        hearts = true
        diamonds = true
        clubs = true
        
        playButton = UIButton(type: UIButton.ButtonType.custom)
        playButton.frame = CGRect(x: CONTROLLEFTOFFSET+(CONTROLSPACE+CONTROLSIZE)*1, y: CONTROLTOPOFFSET, width: CONTROLSIZE, height: CONTROLSIZE)
        playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        playButton.isEnabled = false
        
        exitButton = UIButton(type: UIButton.ButtonType.custom)
        exitButton.frame = CGRect(x: CONTROLLEFTOFFSET+(CONTROLSPACE+CONTROLSIZE)*2, y:CONTROLTOPOFFSET, width: CONTROLSIZE, height: CONTROLSIZE)
        exitButton.setImage(UIImage(named: "quit"), for: UIControl.State.normal)
        exitButton.isEnabled = true
        
        replayButton = UIButton(type: UIButton.ButtonType.custom)
        replayButton.frame = CGRect(x: CONTROLLEFTOFFSET, y:CONTROLTOPOFFSET, width: CONTROLSIZE, height: CONTROLSIZE)
        replayButton.setImage(UIImage(named: "replay"), for: UIControl.State.normal)
        replayButton.isEnabled = false
        
        replayHasBeenPressed = false
        
        game = GameState()
        
        // label to show player name and score
        blueName = ""
        redName = ""
        blueScore = 0
        redScore = 0
        scoreLabel.frame = CGRect(x: 0, y: CONTROLTOPOFFSET-CONTROLSIZE, width: UIScreen.main.bounds.size.width, height: CONTROLSIZE)
        scoreLabel.font = UIFont.systemFont(ofSize: CONTROLSIZE/2)
        scoreLabel.text = "\(game.blueName) vs. \(game.redName) : \(game.blueScore) - \(game.redScore)"
        scoreLabel.textAlignment = NSTextAlignment.center
        
        // store removed card index and its center & rotation
        cardsIndex = [Int]()
        removedCard = [Int: (card: CardView, rotation: CGFloat, center: CGPoint)]()
        
        // super init
        super.init(nibName: nil, bundle: nil)
        
        self.view = UIView(frame: UIScreen.main.bounds)
        
        // add play button
        self.view.addSubview(playButton)
        playButton.addTarget(self, action: #selector(ViewController.playButtonPressed), for: UIControl.Event.touchUpInside)
        
        // add exit button
        self.view.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(ViewController.exitButtonPressed), for: UIControl.Event.touchUpInside)
        
        // add replay button
        self.view.addSubview(replayButton)
        replayButton.addTarget(self, action: #selector(ViewController.replayButtonPressed), for: UIControl.Event.touchUpInside)
        
        // add score label
        self.view.addSubview(scoreLabel)
        
        // add suit images
        self.view.addSubview(clubsImage)
        self.view.addSubview(diamondsImage)
        self.view.addSubview(heartsImage)
        self.view.addSubview(spadesImage)
        
        // add gestures to suit images
        clubsImage.isUserInteractionEnabled = true
        diamondsImage.isUserInteractionEnabled = true
        heartsImage.isUserInteractionEnabled = true
        spadesImage.isUserInteractionEnabled = true
        
        clubsImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.hideSuitImage(_:))))
        diamondsImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.hideSuitImage(_:))))
        heartsImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.hideSuitImage(_:))))
        spadesImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.hideSuitImage(_:))))
        
//        enterNewGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // The following 3 methods were "borrowed" from http://stackoverflow.com/questions/15710853/objective-c-check-if-subviews-of-rotated-uiviews-intersect and converted to Swift
    private func projectionOfPolygon(poly: [CGPoint], onto: CGPoint) ->  (min: CGFloat, max: CGFloat) {
        var minproj: CGFloat = CGFloat.greatestFiniteMagnitude
        var maxproj: CGFloat = -CGFloat.greatestFiniteMagnitude
        for point in poly {
            let proj: CGFloat = point.x * onto.x + point.y * onto.y
            if proj > maxproj {
                maxproj = proj
            }
            if proj < minproj {
                minproj = proj
            }
        }
        return (minproj, maxproj)
    }
    
    private func convexPolygon(poly1: [CGPoint], poly2: [CGPoint]) -> Bool {
        for i in 0..<poly1.count {
            // Perpendicular vector for one edge of poly1:
            let p1: CGPoint = poly1[i];
            let p2: CGPoint = poly1[(i+1) % poly1.count];
            let perp: CGPoint = CGPoint(x: p1.y - p2.y, y: p2.x - p1.x)
            // Projection intervals of poly1, poly2 onto perpendicular vector:
            let (minp1,maxp1): (CGFloat,CGFloat) = self.projectionOfPolygon(poly: poly1, onto: perp)
            let (minp2,maxp2): (CGFloat,CGFloat) = self.projectionOfPolygon(poly: poly2, onto: perp)
            // If projections do not overlap then we have a "separating axis" which means that the polygons do not intersect:
            if maxp1 < minp2 || maxp2 < minp1 {
                return false
            }
        }
        // And now the other way around with edges from poly2:
        for i in 0..<poly2.count {
            // Perpendicular vector for one edge of poly2:
            let p1: CGPoint = poly2[i];
            let p2: CGPoint = poly2[(i+1) % poly2.count];
            let perp: CGPoint = CGPoint(x: p1.y - p2.y, y:
                p2.x - p1.x)
            // Projection intervals of poly1, poly2 onto perpendicular vector:
            let (minp1,maxp1): (CGFloat,CGFloat) = self.projectionOfPolygon(poly: poly1, onto: perp)
            let (minp2,maxp2): (CGFloat,CGFloat) = self.projectionOfPolygon(poly: poly2, onto: perp)
            // If projections do not overlap then we have a "separating axis" which means that the polygons do not intersect:
            if maxp1 < minp2 || maxp2 < minp1 {
                return false
            }
        }
        return true
    }
    
    private func viewsIntersect(view1: UIView, view2: UIView) -> Bool {
        
        return self.convexPolygon(poly1: [view1.convert(view1.bounds.origin, to: nil), view1.convert(CGPoint(x: view1.bounds.origin.x + view1.bounds.size.width, y: view1.bounds.origin.y), to: nil), view1.convert(CGPoint(x: view1.bounds.origin.x + view1.bounds.size.width, y: view1.bounds.origin.y + view1.bounds.height), to: nil), view1.convert(CGPoint(x: view1.bounds.origin.x, y: view1.bounds.origin.y + view1.bounds.height), to: nil)], poly2: [view2.convert(view1.bounds.origin, to: nil), view2.convert(CGPoint(x: view2.bounds.origin.x + view2.bounds.size.width, y: view2.bounds.origin.y), to: nil), view2.convert(CGPoint(x: view2.bounds.origin.x + view2.bounds.size.width, y: view2.bounds.origin.y + view2.bounds.height), to: nil), view2.convert(CGPoint(x: view2.bounds.origin.x, y: view2.bounds.origin.y + view2.bounds.height), to: nil)])
    }
    
    private func cardIsOpenAtIndex(i: Int) -> Bool {
        var j: Int = i+1
        while j < game.board.count && (game.board[j].removed || !self.viewsIntersect(view1: game.board[i], view2: game.board[j])) {
            j += 1
        }
        return (j >= game.board.count)
    }
    
    private func highlightCards() {
        for i in 0..<game.board.count {
            let card: CardView = game.board[i]
            if ((card.suit == "s" && spades) || (card.suit == "h" && hearts) || (card.suit == "d" && diamonds) || (card.suit == "c" && clubs)) && !card.removed && self.cardIsOpenAtIndex(i: i) {
                card.highlight("g")
            }
            else {
                card.highlight("\0")
            }
        }
    }
    
    private func setSuitIndicators() {
        spades = true
        hearts = true
        diamonds = true
        clubs = true
        
        if (game.blueTurn) {
            if (!blueStart) {
                spadesImage.isHidden = false
                heartsImage.isHidden = false
                diamondsImage.isHidden = false
                clubsImage.isHidden = false
            }
            else {
                spadesImage.isHidden = true
                heartsImage.isHidden = true
                diamondsImage.isHidden = true
                clubsImage.isHidden = true
            }
        }
        
        if (!game.blueTurn) {
            if (!redStart) {
                spadesImage.isHidden = false
                heartsImage.isHidden = false
                diamondsImage.isHidden = false
                clubsImage.isHidden = false
            }
            else {
                spadesImage.isHidden = true
                heartsImage.isHidden = true
                diamondsImage.isHidden = true
                clubsImage.isHidden = true
            }
        }
    }
    
    private func updateSuitIndicatorForCard(card: CardView) {
        if card.suit == "s" {
            spades = false
        }
        else if card.suit == "h" {
            hearts = false
        }
        else if card.suit == "d" {
            diamonds = false
        }
        else {
            clubs = false
        }
        
        if spades == false {
            spadesImage.isHidden = true
        }
        if hearts == false {
            heartsImage.isHidden = true
        }
        if diamonds == false {
            diamondsImage.isHidden = true
        }
        if clubs == false {
            clubsImage.isHidden = true
        }
    }
    
    private func setBackground() {
        if game.blueTurn {
            self.view.backgroundColor = BLUE
        }
        else {
            self.view.backgroundColor = RED
        }
    }
    
    private func createCards() {
        let numOfCards: Int = MAXCARDS + Int(arc4random_uniform(UInt32(MAXCARDS/2)))
        var cardValue: String = "b"
        var cardSuit: String = "c"
        var card: CardView
        game.board = [CardView]()
        for _ in 0..<numOfCards {
            card = CardView(suit: cardSuit, value: cardValue)
            game.board.append(card)
            if cardSuit == "c" {
                cardSuit = "d"
            }
            else if cardSuit == "d" {
                cardSuit = "h"
            }
            else if cardSuit == "h" {
                cardSuit = "s"
            }
            else {
                cardSuit = "c"
                if cardValue == "b" {
                    cardValue = "c"
                }
                else if cardValue == "c" {
                    cardValue = "d"
                }
                else if cardValue == "d" {
                    cardValue = "e"
                }
                else {
                    cardValue = "b"
                }
            }
        }
    }
    
    
    private func displayCards() {
        self.displayCard(card: game.board[0], index: 0, rotation: 0.0, center: CGPoint(x: UIScreen.main.bounds.size.width/2.0, y: UIScreen.main.bounds.size.height/2.0))
        for i in 1..<game.board.count {
            let centerloc = CGPoint(x: UIScreen.main.bounds.size.width/2.0 + (arc4random_uniform(2)==0 ? -1.0 : 1.0)*CGFloat(arc4random_uniform(UInt32(CARDWIDTH))), y: UIScreen.main.bounds.size.height/2.0 + (arc4random_uniform(2)==0 ? -1.0 : 1.0)*CGFloat(arc4random_uniform(UInt32(CARDHEIGHT))))
            let rotateRate = CGFloat(arc4random_uniform(45))
            
            self.displayCard(card: game.board[i], index: i, rotation: rotateRate, center: centerloc)
            
            // save info of all cards
            removedCard[i] = (game.board[i], rotateRate, centerloc)
        }
    }
    
    private func displayCard(card: CardView, index: Int, rotation: CGFloat, center: CGPoint) {
        card.index = index
        card.transform = CGAffineTransform(rotationAngle: rotation*CGFloat(Double.pi)/180.0)
        card.center = center
        card.removed = false
        card.isUserInteractionEnabled = true
        card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ViewController.playCard(_:))))
    }
    
    @objc func playCard(_ recognizer: UIPanGestureRecognizer) {
        
        // clear indices of removed cards when playButton is disabled
        // meaning at this time, this is the 1st card's pan gesture
        if !playButton.isEnabled {
            cardsIndex = [Int]()
        }
        
        let card: CardView = recognizer.view as! CardView
        
        if card.highlighted() && !card.removed {
            let translation: CGPoint = recognizer.translation(in: self.view)
            recognizer.view?.center = CGPoint(x: recognizer.view!.center.x + translation.x, y:
                recognizer.view!.center.y + translation.y)
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            if recognizer.state == UIGestureRecognizer.State.ended {
                // save removed card's index and info
                cardsIndex += [card.index]
                print ("\nRemoved cards: \(cardsIndex)")
                
                self.updateSuitIndicatorForCard(card: card)
                card.removed = true
                card.removeFromSuperview()
                
                self.highlightCards()
                playButton.isEnabled = true
                replayButton.isEnabled = false
            }
        }
    }
    
    private func shuffleCards() {
        var card: CardView
        for _ in 0...999 {
            let j: Int = Int(arc4random_uniform(UInt32(game.board.count)))
            let k: Int = Int(arc4random_uniform(UInt32(game.board.count)))
            card = game.board[j]
            game.board[j] = game.board[k]
            game.board[k] = card
        }
    }
    
    private func createBoard() {
        self.createCards()
        self.shuffleCards()
        self.displayCards()
    }
    
    private func displayBoard() {
        for card in game.board {
            if !card.removed {
                self.view.addSubview(card)
            }
        }
    }
    
    private func cleanUpBoard() {
        for card in game.board {
            if !card.removed {
                card.removeFromSuperview()
            }
        }
        game.board = [CardView]()
    }
    

    func enterNewGame() {
        
        self.setBackground()
        self.cleanUpBoard()
        self.createBoard()
        self.displayBoard()
        self.setSuitIndicators()
        self.highlightCards()
        playButton.isEnabled = false
        replayButton.isEnabled = false
        
        // when start new game
        if game.blueScore == 0 && game.redScore == 0 {
            
            game.blueTurn = true
            
            //obtain players' names
            let blueAlert: UIAlertController = UIAlertController(title: "Player 1 Name", message:"Blue player's name: ", preferredStyle: UIAlertController.Style.alert)

            blueAlert.addTextField(configurationHandler: {(t: UITextField) -> Void in
                t.placeholder = "<Enter blue player name>"
                t.textColor = UIColor.blue
            })

            blueAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:
                {(action: UIAlertAction!) -> Void in
                    if blueAlert.textFields?[0].text != "" {
                        self.game.blueName = (blueAlert.textFields?[0].text)!
                        
                        let redAlert: UIAlertController = UIAlertController(title: "Player 2 Name", message:"Red player's name: ", preferredStyle: UIAlertController.Style.alert)
                        
                        redAlert.addTextField(configurationHandler: {(t: UITextField) -> Void in
                            t.placeholder = "<Enter red player name>"
                            t.textColor = UIColor.red
                        })
                        
                        redAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:
                            {(action: UIAlertAction!) -> Void in
                                if redAlert.textFields?[0].text != "" {
                                    self.game.redName = (redAlert.textFields?[0].text)!
                                    self.scoreLabel.text = "\(self.game.blueName) vs. \(self.game.redName) : \(self.game.blueScore) - \(self.game.redScore)"
                                }
                        }))
                        
                        self.present(redAlert, animated: true, completion:
                            {() -> Void in
                        })
                    }
            }))

            self.present(blueAlert, animated: true,completion:
                {() -> Void in
            })

        } //end if
        
        scoreLabel.text = "\(self.game.blueName) vs. \(self.game.redName) : \(self.game.blueScore) - \(self.game.redScore)"
        
    }
    
    // Process the appearance of the keyboard
    @objc func keyboardWillShow(notification: Notification) {
        print("Showing keyboard...")
    }
    
    // Process the disappearance of the keyboard
    @objc func keyboardWillHide(notification: Notification) {
        print("Hiding keyboard...")
    }
    
    // method to indicate whether the game is over or not
    private func checkForWin() -> Bool {
        for i in 0..<game.board.count {
            let card: CardView = game.board[i]
            
            if (!card.removed) {
                return false
            }
        }
        return true
    }
    
    @objc func exitButtonPressed() {
        
        let alert: UIAlertController = UIAlertController(title: "Quit", message: "Do you want to quit the game? The opponent will win.", preferredStyle: UIAlertController.Style.alert)
        
        // show winner if confirm to quit
        alert.addAction(UIAlertAction(title: "Yes", style:UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            
            print ("quit game")
            
            // blue turn quit, red wins
            if self.game.blueTurn {
                print ("winner so far: red")
                
                let endAlert: UIAlertController = UIAlertController(title: "Winner", message: "Winner is \(self.game.redName)", preferredStyle: UIAlertController.Style.alert)
                
                // back to main menu
                endAlert.addAction(UIAlertAction(title: "OK", style:UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                    self.presentingViewController?.dismiss(animated: true, completion: {() -> Void in
                        print("Modal view controller dismissed...")})
                }))
                
                self.present(endAlert, animated: true, completion:
                    {() -> Void in
                        
                })
            }
            // red turn quit, blue wins
            else {
                print ("winner so far: blue")
                
                let endAlert: UIAlertController = UIAlertController(title: "Winner", message: "Winner is \(self.game.blueName)", preferredStyle: UIAlertController.Style.alert)
                
                //back to main menu
                endAlert.addAction(UIAlertAction(title: "OK", style:UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                    self.presentingViewController?.dismiss(animated: true, completion: {() -> Void in
                        print("Modal view controller dismissed...")})
                }))
                
                self.present(endAlert, animated: true, completion:
                    {() -> Void in
                        
                })
            }
        }))
        
        // cancel quitting game
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion:
            {() -> Void in
                
        })
        
    }
    
    @objc func replayButtonPressed(_ recognizer: UITapGestureRecognizer) {
        
        replayHasBeenPressed = true
        replayButton.isEnabled = false
        game.blueTurn = !game.blueTurn
        setBackground()
        setSuitIndicators()
        
        print("\n*REPLAY*\nPrevious round blue: \(game.blueTurn)\nRemoved cards: \(cardsIndex)")
        
        // put back cards
        for i in cardsIndex {
            game.board[i].removed = false
            displayCard(card: game.board[i], index: i, rotation: removedCard[i]!.rotation, center: removedCard[i]!.center)
        }
        
        // show board as previous round
        self.displayBoard()
        self.highlightCards()
        
        // add animation of removing cards by recursion method
        // when finishes, set backagound as current round
        slideCards( array: cardsIndex, index: 0)
    }
    
    // recursion method to handle animation of sliding cards
    private func slideCards(array: [Int], index: Int) {

        // replay how previous player played
        if index < array.count {
            let card: CardView = game.board[array[index]]
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                () -> Void in
                self.highlightCards()
                card.center = CGPoint(x: UIScreen.main.bounds.size.width, y: UIScreen.main.bounds.size.height)
            }, completion: {
                (Bool) -> Void in
                card.removed = true
                card.removeFromSuperview()
                self.updateSuitIndicatorForCard(card: card)
                self.slideCards(array: array, index: index+1)
            })
        }
        // after going through all cards, set board back to current play's settings
        else {
            self.game.blueTurn = !self.game.blueTurn
            self.setBackground()
            self.setSuitIndicators()
            self.displayBoard()
            self.highlightCards()
            self.replayButton.isEnabled = true
        }
    }
    
    @objc func playButtonPressed() {
        playButton.isEnabled = false
        replayButton.isEnabled = true
        // once playbutton is clicked, reset replayHasBeenPressed
        replayHasBeenPressed = false
        game.blueTurn = !game.blueTurn
        self.setBackground()
        self.setSuitIndicators()
        self.highlightCards()
        
        print ("Game end? -", checkForWin())
        
        // reset cardsIndex array of removed cards once replay finished and play button clicked again
        if replayHasBeenPressed {
            replayButton.isEnabled = false
            cardsIndex = [Int]()
        }
        
        // alert indicating who's win when game ends
        if checkForWin() {

            if !game.blueTurn {
                game.blueScore += 1
                print ("blue wins")
            }
            else {
                game.redScore += 1
                print ("red wins")
            }
            
            // game ends when one player gets 2 wins
            if game.blueScore == 2 || game.redScore == 2 {
                
                print ("we have a winner")
                
                if self.game.blueScore == 2 {
                    let alert: UIAlertController = UIAlertController(title: "Game Winner", message: "The winner goes to ... \(self.game.blueName)!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style:UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                        
                        self.presentingViewController?.dismiss(animated: true, completion: {() -> Void in
                            print("Modal view controller dismissed...")})
                    }))
                    
                    self.present(alert, animated: true, completion:
                        {() -> Void in
                            
                    })
                }
                    
                if self.game.redScore == 2 {
                    let alert: UIAlertController = UIAlertController(title: "Game Winner", message: "The winner goes to ... \(self.game.redName)!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style:UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                        
                        self.presentingViewController?.dismiss(animated: true, completion: {() -> Void in
                            print("Modal view controller dismissed...")})
                    }))
                    
                    self.present(alert, animated: true, completion:
                        {() -> Void in
                            
                    })
                }
            }
            // if no one gets 2 scores then game continues
            else {
                if self.game.blueTurn {
                    print ("red wins")
                    
                    let alert: UIAlertController = UIAlertController(title: "Round Winner", message: "This round winner is \(self.game.redName)", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Next round", style:UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                        self.game.blueTurn = true
                        self.enterNewGame()
                    }))
                    
                    self.present(alert, animated: true, completion:
                        {() -> Void in
                            
                    })
                }
                else {
                    print ("blue wins")
                    
                    let alert: UIAlertController = UIAlertController(title: "Round Winner", message: "This round winner is \(self.game.blueName)", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Next round", style:UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                        self.game.blueTurn = false
                        self.enterNewGame()
                    }))
                    
                    self.present(alert, animated: true, completion:
                        {() -> Void in
                            
                    })
                }

                print ("game continues")
            }
        }
    }
    
    @objc func hideSuitImage(_ recognizer: UITapGestureRecognizer) {
        if (game.blueTurn) {
            blueStart = true
        }
        else {
            redStart = true
        }
        
        clubsImage.isHidden = true
        spadesImage.isHidden = true
        heartsImage.isHidden = true
        diamondsImage.isHidden = true
        
    }
    
    
 }
 

