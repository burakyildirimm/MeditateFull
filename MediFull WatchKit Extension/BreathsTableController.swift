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
        
        let huzur = Breath(name: "Huzur", color: UIColor.blue, takeTime: 3, holdTime: 3, outTime: 12)
        let sakin = Breath(name: "Sakinlik", color: UIColor.red, takeTime: 6, holdTime: 3, outTime: 3)
        let stres = Breath(name: "Stres", color: UIColor.blue, takeTime: 5, holdTime: 3, outTime: 3)
        let uyku = Breath(name: "Uyku", color: UIColor.red, takeTime: 9, holdTime: 3, outTime: 3)
        
        breaths.append(huzur)
        breaths.append(sakin)
        breaths.append(stres)
        breaths.append(uyku)
        
        //Will delete!
        breaths.append(huzur)
        breaths.append(sakin)
        breaths.append(stres)
        breaths.append(uyku)
        
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
