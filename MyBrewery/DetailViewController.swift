//
//  DetailViewController.swift
//  MyBrewery
//
//  Created by Finley on 2022/06/18.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UITableViewController{
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    private func configuration(){
        title = beer?.name ?? "no name"
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailLisetCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        
        let headerView = UIImageView(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 300))
        let imageURL = URL(string: beer?.imageURL ?? "")
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon"))
        tableView.tableHeaderView = headerView
    }
}


extension DetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return beer?.foodParing.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ID"
        case 1:
            return "Description"
        case 2:
            return "Brewers Tips"
        case 3:
            let foodParing = beer?.foodParing.count ?? 0
            let containFoodParing = foodParing != 0
            return containFoodParing ? "Food Paring" : nil
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = String(describing: beer?.id ?? 0)
            return cell
        case 1:
            cell.textLabel?.text = beer?.description ?? "no Description"
            return cell
        case 2:
            cell.textLabel?.text = beer?.brewersTips ?? "no Tips"
            return cell
        default:
            cell.textLabel?.text = beer?.foodParing[indexPath.row] ?? ""
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.textColor = .black
    }
}
