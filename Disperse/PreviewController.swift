//
//  PreviewController.swift
//  Disperse
//
//  Created by Jiawei Zhou on 3/3/19.
//  Copyright © 2019 Sherry Zhou. All rights reserved.
//

import UIKit

// Lab 4 - Method to handle tap in welcoming screen and invoke enterGame()

class PreviewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGSize = UIScreen.main.bounds.size
        let centerX: CGFloat = screenSize.width / 2
        let centerY: CGFloat = screenSize.height / 2
        let CARDWIDTH: CGFloat = UIScreen.main.bounds.size.width / 4.0
        let CARDHEIGHT: CGFloat = 214.0 * CARDWIDTH / 150.0
        
        let aceClub: UIImageView = UIImageView()
        let aceDiamond: UIImageView = UIImageView()
        let aceHeart: UIImageView = UIImageView()
        let aceSpade: UIImageView = UIImageView()
        let startLabel: UILabel = UILabel()
        
        // purple background
//        self.view = UIView(frame: UIScreen.main.bounds)
//        self.view.backgroundColor = UIColor.purple
        
        // display four aces
        aceClub.frame = CGRect(x: centerX-CARDWIDTH*1.25, y: centerY-100, width: CARDWIDTH, height: CARDHEIGHT)
        aceClub.image = UIImage(named: "AceOfClubs.png")
        aceClub.transform = CGAffineTransform(rotationAngle: -30.0*CGFloat(Double.pi)/180.0)
        self.view.addSubview(aceClub)
        
        aceDiamond.frame = CGRect(x: centerX-CARDWIDTH*0.75, y: centerY-100, width: CARDWIDTH, height: CARDHEIGHT)
        aceDiamond.image = UIImage(named: "AceOfDiamonds.png")
        aceDiamond.transform = CGAffineTransform(rotationAngle: -15.0*CGFloat(Double.pi)/180.0)
        self.view.addSubview(aceDiamond)
        
        aceHeart.frame = CGRect(x: centerX-CARDWIDTH*0.25, y: centerY-100, width: CARDWIDTH, height: CARDHEIGHT)
        aceHeart.image = UIImage(named: "AceOfHearts.png")
        aceHeart.transform = CGAffineTransform(rotationAngle: 15.0*CGFloat(Double.pi)/180.0)
        self.view.addSubview(aceHeart)
        
        aceSpade.frame = CGRect(x: centerX+CARDWIDTH*0.25, y: centerY-100, width: CARDWIDTH, height: CARDHEIGHT)
        aceSpade.image = UIImage(named: "AceOfSpades.png")
        aceSpade.transform = CGAffineTransform(rotationAngle: 30.0*CGFloat(Double.pi)/180.0)
        self.view.addSubview(aceSpade)
        
        // startLabel
        startLabel.text = "Start Game"
        startLabel.textAlignment = NSTextAlignment.center
        startLabel.textColor = UIColor.white
        startLabel.backgroundColor = UIColor.black
        startLabel.frame = CGRect(x: centerX-75, y: centerY+200, width: 150, height: 50)
        startLabel.isUserInteractionEnabled = true
        startLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PreviewController.startTap(_:))))
        self.view.addSubview(startLabel)
    }
    
    // tap Start to add modal view controller and invoke enterGame()
    @objc func startTap(_ recognizer: UITapGestureRecognizer) {
        let vc: ViewController = ViewController()
        self.present(vc, animated: true, completion: {() -> Void in
            print("Modal view controller presented...")
        })
        
        vc.enterNewGame()
    }
}
