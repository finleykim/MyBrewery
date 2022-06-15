//
//  ViewController.swift
//  MyBrewery
//
//  Created by Finley on 2022/06/15.
//

import UIKit
import SnapKit
import Kingfisher
import Lottie

class BeerListController: UIViewController {

    let backgroundView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    private func setup(){
        [backgroundView].forEach{
            view.addSubview($0)
        }
        
        backgroundView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        
    }
    
    
    
}


extension BeerListController{
    
}
