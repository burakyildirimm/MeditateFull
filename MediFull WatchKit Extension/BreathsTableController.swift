//
//  CheckInInterfaceController.swift
//  MediFull WatchKit Extension
//
//  Created by Burak Yıldırım on 6.10.2020.
//  Copyright © 2020 Burak Yıldırım. All rights reserved.
//

import WatchKit
import Foundation


class BreathsTableController: WKInterfaceController {
    
    
    @IBOutlet weak var breathsTable: WKInterfaceTable!
    
    var breaths: [Breath] = []
    
    
    override func awake(withContext context: Any?) {
      super.awake(withContext: context)
        
        let peaceful = Breath(name: "Peaceful", color: UIColor.blue, takeTime: 4, holdTime: 7, outTime: 8)
        let kapalabati = Breath(name: "Morning Bomb", color: UIColor.red, takeTime: 3, holdTime: 2, outTime: 2)
        let muscle = Breath(name: "Muscle Relaxing", color: UIColor.blue, takeTime: 4, holdTime: 5, outTime: 6)
        let life = Breath(name: "Life Breath", color: UIColor.red, takeTime: 4, holdTime: 5, outTime: 8)
        let stress = Breath(name: "Stress", color: UIColor.blue, takeTime: 3, holdTime: 6, outTime: 4)
        let sleep = Breath(name: "Sleep", color: UIColor.red, takeTime: 4, holdTime: 0, outTime: 4)
        let calm = Breath(name: "Calm", color: UIColor.blue, takeTime: 4, holdTime: 0, outTime: 2)
        
        breaths.append(peaceful)
        breaths.append(kapalabati)
        breaths.append(muscle)
        breaths.append(life)
        breaths.append(stress)
        breaths.append(sleep)
        breaths.append(calm)
        
        loadTableData()
    }
    
    
    private func loadTableData() {
        breathsTable.setNumberOfRows(breaths.count, withRowType: "BreathRow")
        
        for (index, rowModel) in breaths.enumerated() {
            
            if let rowController = breathsTable.rowController(at: index) as? BreathRowController {
                rowController.breathLabel.setText(rowModel.name)
                rowController.mySeperator.setColor(rowModel.color)
            }
            
        }
    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "actionBreath", context: breaths[rowIndex])
    }
    
}
