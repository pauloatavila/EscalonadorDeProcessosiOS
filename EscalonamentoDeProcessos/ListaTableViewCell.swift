//
//  ListaTableViewCell.swift
//  EscalonamentoDeProcessos
//
//  Created by Paulo Sérgio Atavila Júnior on 24/10/17.
//  Copyright © 2017 Paulo Atavila. All rights reserved.
//

import UIKit

class ListaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var processoView: UIView!
    @IBOutlet weak var nomeProcessoLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
