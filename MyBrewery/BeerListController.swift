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
    let animationView = AnimationView(name: "seawaves")
    let mainLabel = UILabel()
    let topLogo = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewSetup()
        setup()
        backgroundGradient()
    }
    
    private func addViewSetup(){
        
        
        [backgroundView,animationView,topLogo,mainLabel].forEach{
            view.addSubview($0)
        }
        
        backgroundView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        animationView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(250)
            $0.leading.trailing.equalToSuperview()
        }
        
        topLogo.snp.makeConstraints{
            $0.top.equalToSuperview().inset(50)
          
        }
        
        mainLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        
    }
    
    private func setup(){
        
        animationView.backgroundColor = .systemBackground
        animationView.loopMode = .loop
        animationView.play()
        
        topLogo.image = UIImage(named: "logo")
        
        mainLabel.font = .systemFont(ofSize: 18.0, weight: .black)
        mainLabel.text = "로드되었음"
        mainLabel.textColor = .black
        
        
    }
    
    private func backgroundGradient(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(red: 139, green: 152, blue: 206, alpha: 1).cgColor,
                           UIColor(red: 255, green: 180, blue: 180, alpha: 1).cgColor,
                           UIColor(red: 255, green: 165, blue: 121, alpha: 1).cgColor,
                           UIColor(red: 255, green: 59, blue: 59, alpha: 1).cgColor]
        gradient.locations = [0,0, 0.2, 0.6, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.backgroundView.layer.insertSublayer(gradient,at: 0)
        
    }
    
    
}


extension BeerListController{
    
}
