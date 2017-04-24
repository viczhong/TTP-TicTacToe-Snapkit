//
//  GameViewController.swift
//  TTP-TicTacToe
//
//  Created by Victor Zhong on 4/21/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit
import AudioToolbox
import AVFoundation

class GameViewController: UIViewController {
    
    //Mark: - Properties
    var isPlayerOneTurn = true
    
    let ticTacToe = TicTacToe()
    var moveCounter = 0 // to determine if game is tied
    
    var time = 0.0
    var timer: Timer!
    
    var player: AVAudioPlayer? // for winning sound effect
    
    let initialLabelString = "Player One's turn! Place an X"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGameView()
    }
    
    // MARK: - Game Setup
    func setupGameView() {
        setupGridView()
        setupStatusLabel()
        setupResetButton()
        ticTacToe.resetGameState()
    }
    
    // MARK: - View Constraints
    func setupGridView() {
        view.addSubview(gridView)
        
        gridView.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.centerY.equalToSuperview()
            view.height.width.equalTo(260)
        }
        
        // first-time setup for 3x3 buttons within the grid
        for row in 0..<ticTacToe.rowAndColumnSize {
            for col in 0..<ticTacToe.rowAndColumnSize {
                //we construct the button base on row and col value
                constructButtonAt(row, col)
            }
        }
    }
    
    func setupStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.text = initialLabelString
        
        statusLabel.snp.makeConstraints { (view) in
            view.bottom.equalTo(gridView.snp.top).offset(-16)
            view.centerX.equalTo(gridView.snp.centerX)
        }
    }
    
    func setupResetButton() {
        view.addSubview(resetButton)
        resetButton.setTitle(resetButtonName, for: UIControlState())
        resetButton.setTitleColor(.white, for: UIControlState())
        resetButton.backgroundColor = .blue
        resetButton.addTarget(self, action: #selector(playerWantsToReset), for: .touchUpInside)
        
        resetButton.snp.makeConstraints { (view) in
            view.top.equalTo(gridView.snp.bottom).offset(16)
            view.centerX.equalTo(gridView.snp.centerX)
            view.height.equalTo(50)
            view.width.equalTo(100)
        }
    }
    
    func resetAllButtons(shouldResetButtonColor resetColor: Bool, shouldEnableButton: Bool) {
        for v in gridView.subviews {
            guard let button = v as? UIButton, let title = button.currentTitle else { continue }
            if title != resetButtonName {
                if resetColor {
                    button.backgroundColor = .white
                    button.setImage(nil, for: .disabled)
                }
                
                button.isEnabled = shouldEnableButton
            }
        }
    }
    
    /* Since we intend for the size of each square to be 80*80, we position them within a 90*90 origin point inside the gridContainer to prevent buttons from overlapping, and to give it the distinctive black # grid we know and love in Tic Tac Toe */
    
    func constructButtonAt(_ row: Int, _ col: Int) {
        let xValue = (col * 90)
        let yValue = (row * 90)
        let frame = CGRect(x: xValue, y: yValue, width: 80, height: 80)
        
        // construct the button within the frame
        let button = UIButton(frame: frame)
        
        // set the background color to white
        button.backgroundColor = .white
        
        // set the title to a clear string that stores the coordinate of the button (for use in determining which button was clicked without using tags)
        let title = "\(row),\(col)"
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(.clear, for: UIControlState())
        
        // attach "playerMadeLegalMove" to the button
        button.addTarget(self, action: #selector(playerMadeLegalMove), for: .touchUpInside)
        
        // finally, add button to the view
        gridView.addSubview(button)
    }
    
    
    // MARK: - Player Functions
    func playerWantsToReset(_ resetButton: UIButton) {
        // reset everything
        isPlayerOneTurn = true
        resetAllButtons(shouldResetButtonColor: true, shouldEnableButton: true)
        ticTacToe.resetGameState()
        statusLabel.text = initialLabelString
        moveCounter = 0
    }
    
    func playerMadeLegalMove(_ button: UIButton) {
        // audio feedback!
        AudioServicesPlaySystemSound(1104)
        
        // disable the button once it's tapped
        button.isEnabled = false
        
        // increment moveCounter by one
        moveCounter += 1
        
        // grab the title of the button to determine the position of the button
        guard let title = button.currentTitle else { return }
        
        // convert the position string to a tuple for use in other functions
        let indexValue = ticTacToe.convertStringToTupleFrom(title)
        
        // check which player's turn, then resolve win checks and pass control over to other player
        if isPlayerOneTurn {
            ticTacToe.setMarkOn(indexValue, forPlayer: .playerOne)
            button.setImage(UIImage(named: "xicon"), for: .disabled)
            isPlayerOneTurn = false
            statusLabel.text = "Player Two's turn! Place an O"
        } else {
            ticTacToe.setMarkOn(indexValue, forPlayer: .playerTwo)
            button.setImage(UIImage(named: "oicon"), for: .disabled)
            isPlayerOneTurn = true
            statusLabel.text = "Player One's turn! Place an X"
        }
        
        // if there's a winner grab the player's Name and display it on gameTitleLabel and reset all the button color and state
        if let playerName = ticTacToe.returnWinningPlayer() {
            statusLabel.text = playerName
            
            playFanFare(playerName)
            
            resetAllButtons(shouldResetButtonColor: false, shouldEnableButton: false)
        } else if moveCounter == 9 {
            statusLabel.text = "Tied!"
        }
    }
    
    func playFanFare(_ playerWinString: String) {
        if !self.view.subviews.contains(fanfare) {
            self.view.addSubview(fanfareLabel)
            self.view.addSubview(fanfare)
        } else {
            fanfare.alpha = 1
            fanfareLabel.alpha = 1
        }
        
        fanfareLabel.snp.makeConstraints { view in
            view.bottom.equalTo(statusLabel.snp.top).offset(-16)
            view.centerX.equalToSuperview()
            view.width.equalToSuperview()
        }
        
        fanfare.snp.makeConstraints { view in
            view.top.bottom.equalToSuperview()
            view.leading.trailing.equalToSuperview()
        }
        
        fanfareLabel.text = playerWinString
        playFanfareSound()
        
        self.time = 0
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkTime), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    func checkTime () {
        if self.time >= 2.6  {
            fanfareLabel.alpha = 0
            
            UIView.animate(withDuration: 1, animations: {
                self.fanfare.alpha = 0
            })
            
            timer.invalidate()
        }
        
        self.time += 0.1
    }
    
    //MARK: - AVFoundation Stuff
    func playFanfareSound() {
        let url = Bundle.main.url(forResource: "fanfare", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Views and Lazy Views
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let gridView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let resetButtonName = "Reset Game"
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var fanfare: UIView = {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 700)
        
        // from https://www.invasivecode.com/weblog/caemitterlayer-and-the-ios-particle-system-lets/?doing_wp_cron=1489935545.9552049636840820312500 and https://www.hackingwithswift.com/example-code/calayer/how-to-emit-particles-using-caemitterlayer
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.frame.midX, y: view.frame.minY)
        emitterLayer.emitterZPosition = 10
        emitterLayer.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        
        func makeCell(color: UIColor) -> CAEmitterCell {
            let cell = CAEmitterCell()
            cell.birthRate = 10
            cell.lifetime = 7.0
            cell.lifetimeRange = 0
            cell.velocity = 100
            cell.velocityRange = 50
            cell.yAcceleration = 250
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 2
            cell.spinRange = 3
            cell.scale = 0.1
            cell.scaleRange = 0.5
            cell.scaleSpeed = -0.05
            cell.contents =  UIImage(named: "bullet")?.cgImage
            cell.color = color.cgColor
            
            return cell
        }
        
        let green = makeCell(color: UIColor.green)
        let white = makeCell(color: UIColor.white)
        let blue = makeCell(color: UIColor.blue)
        
        emitterLayer.emitterCells = [green, white, blue]
        view.layer.addSublayer(emitterLayer)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return view
    }()
    
    lazy var fanfareLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir-LightOblique", size: 36)
        label.textAlignment = .center
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor.blue.withAlphaComponent(0.8)
        return label
    }()
    
    
}
