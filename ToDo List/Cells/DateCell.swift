//
//  DateCell.swift
//  ToDo List
//
//  Created by Евгений Пашко on 10.12.2021.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    
    func setDate(_ date: Date) {
        label.text = date.formattedDate
    }

}
