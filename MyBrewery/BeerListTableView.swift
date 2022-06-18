//
//  BeerListView.swift
//  MyBrewery
//
//  Created by Finley on 2022/06/17.
//

import Foundation
import UIKit


class BeerListTableView: UITableView{
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        self.register(BeerListTableViewCell.self, forCellReuseIdentifier: "BeerListTableViewCell")
        self.rowHeight = 100
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
