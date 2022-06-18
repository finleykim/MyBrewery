//
//  BeerListCell.swift
//  MyBrewery
//
//  Created by Finley on 2022/06/16.
//


import UIKit
import SnapKit
import Kingfisher

class BeerListTableViewCell: UITableViewCell{
    
    var beer: Beer?
    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let taglineLabel = UILabel()
    
    override func layoutSubviews() {
        
        //addSubview, autoLayout
        [beerImageView,nameLabel,taglineLabel].forEach{
            contentView.addSubview($0)
        }
        
        beerImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints{
            $0.leading.equalTo(beerImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(beerImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints{
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        cofiguration()
    }
    

    func cofiguration(){
        guard let beer = beer else { return }
        
        let imageURL = URL(string: beer.imageURL)
        beerImageView.contentMode = .scaleAspectFit
        beerImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon"))

        nameLabel.text = beer.name
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 2

        taglineLabel.text = beer.tagline
        taglineLabel.backgroundColor = .darkGray
        taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    

}
