//
//  NoteCell.swift
//  Perspective
//
//  Created by Apprentice on 2/18/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var notebutton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
