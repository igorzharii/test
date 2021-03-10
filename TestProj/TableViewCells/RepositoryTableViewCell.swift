//
//  RepositoryTableViewCell.swift
//  TestProj
//
//  Created by Igor Zharii on 02.03.2021.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    static let identifier = "RepositoryCell"
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
