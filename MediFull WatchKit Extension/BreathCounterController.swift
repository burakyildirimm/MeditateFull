//
//  InterfaceController.swift
//  MediFull WatchKit Extension
//
//  Created by Burak Yıldırım on 5.10.2020.
//  Copyright © 2020 Burak Yıldırım. All rights reserved.
//

import WatchKit
import Foundation


var globalTakeBreathTime = 5
var globalBreathOutTime = 10
var globalHoldTime = 3


class BreathCounterController: WKInterfaceController {

    @IBOutlet weak var breathCircle: WKInterfaceGroup!
    @IBOutlet weak var myTimer: WKInterfaceLabel!
    @IBOutlet weak var inOutLabel: WKInterfaceLabel!
    
    
    var circleMinSize = 68
    var circleMaxSize = 116
    var circleStepSize = 0.0
    
    var circleSize = 68.0
    var circleRadius = 34.0
    var isBreath: Bool = true
    var elapsedTime = 0
    
    var takeBreathTime = 0
    var breathOutTime = 0
    var holdTime = 0
    var holdElapsedTime = 0
    
    var holdText = ""
    
    var takeBreathColor = UIColor(red: 0.50, green: 0.47, blue: 1.00, alpha: 1.00)
    var holdBreathColor = UIColor(red: 0.98, green: 0.07, blue: 0.31, alpha: 1.00)
    
    var timer: Timer?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        // Configure interface objects here.
        
        if let detailData = context as? Breath {
            globalBreathOutTime = detailData.outTime
            globalTakeBreathTime = detailData.takeTime
            globalHoldTime = detailData.holdTime
            
            var tempData: Int
            
            if ( detailData.takeTime > detailData.outTime ) {
                tempData = detailData.takeTime % detailData.outTime
            } else {
                tempData = detailData.outTime % detailData.takeTime
            }
            
            if ( tempData != 0 ) {
                var circleOpt = (circleMaxSize - circleMinSize) % (detailData.takeTime * detailData.outTime)
                
                if ( circleOpt != 0 ) {
                    let tempValue = round(Double(detailData.takeTime * detailData.outTime))
                    circleOpt = (circleMaxSize - circleMinSize) / Int(tempValue)
                    circleOpt = Int(round(Double(circleOpt)))
                    
                    circleMinSize += circleOpt
                    circleSize = Double(circleMinSize)
                    circleRadius = circleSize / 2
                }
            } else{
                var circleOptTake = (circleMaxSize - circleMinSize) % (detailData.takeTime)
                var circleOptOut = (circleMaxSize - circleMinSize) % (detailData.outTime)
                
                if ( circleOptTake != 0 ) {
                    let tempValue = round(Double(detailData.takeTime))
                    circleOptTake = (circleMaxSize - circleMinSize) / Int(tempValue)
                    circleOptTake = Int(round(Double(circleOptTake)))
                    
                    let restValue = (circleMaxSize - circleMinSize) - (circleOptTake * detailData.takeTime)
                    
                    
                    circleMinSize += restValue
                    circleSize = Double(circleMinSize)
                    circleRadius = circleSize / 2
                } else if ( circleOptOut != 0 ) {
                    let tempValue = round(Double(detailData.outTime))
                    circleOptOut = (circleMaxSize - circleMinSize) / Int(tempValue)
                    circleOptOut = Int(round(Double(circleOptOut)))
                    
                    let restValue = (circleMaxSize - circleMinSize) - (circleOptTake * detailData.takeTime)

                    
                    circleMinSize += restValue
                    circleSize = Double(circleMinSize)
                    circleRadius = circleSize / 2
                }
            }
            
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        circleStepSize = Double((circleMaxSize - circleMinSize) / globalTakeBreathTime)
        breathOutTime = globalBreathOutTime
        takeBreathTime = globalTakeBreathTime
        holdTime = globalHoldTime
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        timer?.invalidate()
    }
    
    @objc func fire() {
        
        if ( elapsedTime == takeBreathTime ) {
            inOutLabel.setText("Breath Out")
            
            var temporaryBreath = isBreath
            
            isBreath = false
            takeBreathTime = 9999
            
            breathOutTime = globalBreathOutTime
            elapsedTime = globalBreathOutTime
            
            circleStepSize = Double((circleMaxSize - circleMinSize) / globalBreathOutTime)
            
            
            // Hold Control!
            if ( temporaryBreath != isBreath ) {
                holdElapsedTime = 0
                holdText = ""
                inOutLabel.setText(holdText)
            }
            
            temporaryBreath = !temporaryBreath
            
        } else if ( elapsedTime == 0 ) {
            inOutLabel.setText("Breath In")
            
            var temporaryBreath = isBreath
            
            isBreath = true
            breathOutTime = 9999
            
            takeBreathTime = globalTakeBreathTime
            elapsedTime = 0
            
            circleStepSize = Double((circleMaxSize - circleMinSize) / globalTakeBreathTime)
            
            // Hold Control!
            if ( temporaryBreath != isBreath ) {
                holdElapsedTime = 0
                holdText = ""
                inOutLabel.setText(holdText)
            }
            
            temporaryBreath = !temporaryBreath
            
        }
        
        
        
        
        if ( isBreath ) {
            
            if ( holdElapsedTime == holdTime ) {
                inOutLabel.setTextColor(UIColor.white)
                elapsedTime += 1
                circleSize += circleStepSize
                circleRadius += circleStepSize / 2
                breathCircle.setCornerRadius(CGFloat(circleRadius))
                
                inOutLabel.setText("Breath In")
            } else {
                inOutLabel.setTextColor(UIColor.white)
                holdText += "."
                holdElapsedTime += 1
                inOutLabel.setText(holdText)
            }
            
        } else {
            
            if ( holdElapsedTime == holdTime ) {
                inOutLabel.setTextColor(UIColor.white)
                elapsedTime -= 1
                circleSize -= circleStepSize
                circleRadius -= circleStepSize / 2
                breathCircle.setCornerRadius(CGFloat(circleRadius))
                
                inOutLabel.setText("Breath Out")
            } else {
                inOutLabel.setTextColor(UIColor.white)
                holdText += "."
                holdElapsedTime += 1
                inOutLabel.setText(holdText)
            }
            
        }
        
        myTimer.setText(String(elapsedTime))
        
        breathCircle.setWidth(CGFloat(circleSize))
        breathCircle.setHeight(CGFloat(circleSize))
        
    }
    

}
