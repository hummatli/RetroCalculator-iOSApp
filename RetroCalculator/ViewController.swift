//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Settar Hummetli on 7/15/17.
//  Copyright © 2017 Settar Hummetli. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var lblOutput: UILabel!
    @IBOutlet weak var btnDivide: UIButton!
    @IBOutlet weak var btnMultiply: UIButton!
    @IBOutlet weak var btnSubtract: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnEquals: UIButton!
    
    var btnSound: AVAudioPlayer!
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    
    var currentOperation = Operation.Empty
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
        lblOutput.text = "0"
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        runningNumber += "\(sender.tag)"
        lblOutput.text = runningNumber
    }
    
 
    @IBAction func onOtherBtnsPressed(sender: UIButton) {
        switch sender {
        case btnDivide:
            prosessOperation(operation: .Divide)
        case btnMultiply:
            prosessOperation(operation: .Multiply)
        case btnSubtract:
            prosessOperation(operation: .Subtract)
        case btnAdd:
            prosessOperation(operation: .Add)
        case btnEquals:
            prosessOperation(operation: currentOperation)
        default:
            print("Btn has not specified")
        }
        
    }
    
    @IBAction func btnClearPressed(_ sender: Any) {
        playSound()
        lblOutput.text = "0"
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        result = ""
        currentOperation = Operation.Empty
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func prosessOperation(operation: Operation) {
        
        playSound()
        if currentOperation != Operation.Empty {
            
            //User selected n operator, but then selected another operator without first entering a number
            
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
            
                switch currentOperation {
                case Operation.Multiply:
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                case Operation.Divide:
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                case Operation.Subtract:
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                case Operation.Add:
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                default:
                    break
                }
                
                leftValStr = result
                lblOutput.text = result
        
            }
            
            currentOperation = operation
        } else {
            //This is first time an opertaor pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
        
    }
  

}

