//
//  UserTableViewCell.swift
//  TestProj
//
//  Created by Igor Zharii on 02.03.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
