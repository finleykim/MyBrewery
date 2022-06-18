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
        
        guard let beer = beer else { return }
        
        let imageURL = URL(string: beer.imageURL ?? "")
        beerImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon"))

        nameLabel.text = beer.name ?? "NoName"
        nameLabel.font = .systemFont(ofSize: 13, weight: .bold)

        taglineLabel.text = beer.tagline
        taglineLabel.backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 132/255, alpha: 0.8)
        taglineLabel.font = .systemFont(ofSize: 10, weight: .regular)
        
        
        
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
    }
    
  
//    private func configuration(){
//        beerImageView.image = UIImage(named: "beer_icon")
//
//        nameLabel.text = "이름없는맥주"
//        nameLabel.font = .systemFont(ofSize: 13, weight: .bold)
//        nameLabel.textColor = .black
//
//        taglineLabel.text = "taglineLabel"
//        taglineLabel.backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 132/255, alpha: 0.8)
//        taglineLabel.font = .systemFont(ofSize: 10, weight: .regular)
//        taglineLabel.textColor = .black
//
//        accessoryType = .disclosureIndicator
//        selectionStyle = .none
//    }
    
    
    

}
