//
//  NoteListTableViewCell.swift
//  Notes_Sample
//
//  Created by Ashwini on 03/02/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateData(data : Note) {
        self.noteTitleLabel!.text = data.title
        self.noteDescriptionLabel!.text = data.noteDetail
        self.creationDateLabel!.text = Date.convertDate(date: data.creationDate!)
    }
}
