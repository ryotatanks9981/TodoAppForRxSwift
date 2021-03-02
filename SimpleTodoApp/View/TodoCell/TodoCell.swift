//
//  TodoCell.swift
//  SimpleTodoApp
//
//  Created by Ryota Karita on 2021/03/02.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var detaiiLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(usingViewModel model: TodoCellViewPresentable) {
        titileLabel.text = model.title
        detaiiLabel.text = model.detail
    }
}
