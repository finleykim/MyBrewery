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

class MainViewController: UIViewController {
    
    
    
    
    let searchView = UISearchBar()
    let animationView = AnimationView(name: "seawaves")
    let camera = UIButton()
    let album = UIButton()
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewSetup()
        configuration()
        backgroundGradient()
    }
    
    private func addViewSetup(){
        
        //commonSet
        let buttonWidth: CGFloat = 30
        let buttonInset: CGFloat = 16.0
        let sideSpacing : CGFloat = -10
        let topSpacing: CGFloat = 30
        
        [animationView,camera,album,searchView].forEach{
            view.addSubview($0)
        }
        
        animationView.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(-300)
            $0.leading.trailing.equalToSuperview()
        }
        
        camera.snp.makeConstraints{
             $0.trailing.equalTo(album.snp.leading).offset(sideSpacing)
             $0.top.equalToSuperview().inset(topSpacing)
             $0.width.equalTo(buttonWidth)
             $0.height.equalTo(buttonWidth)
        }
        
        album.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(buttonInset)
            $0.top.equalToSuperview().inset(topSpacing)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonWidth)
        }
        
        searchView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(topSpacing)
            $0.trailing.equalTo(camera.snp.leading).offset(sideSpacing)
            $0.leading.equalToSuperview().inset(10)
        }

    }
    
    private func configuration(){
        animationView.loopMode = .loop
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        
        camera.setImage(UIImage(systemName: "camera"), for: .normal)
        album.setImage(UIImage(systemName: "photo"), for: .normal)
    
        searchView.searchTextField.backgroundColor = UIColor.white
    }
    
    
    private func navigationItemsConfiguration(){
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search your beer"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    private func filterContetnForSearchText(_ searchText: String){
        //검색결과
    }
    
    
    private func backgroundGradient(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(red: 139/255, green: 152/255, blue: 206/255, alpha: 1).cgColor,
                           UIColor(red: 255/255, green: 180/255, blue: 180/255, alpha: 1).cgColor,
                           UIColor(red: 255/255, green: 165/255, blue: 121/255, alpha: 1).cgColor,
                           UIColor(red: 255/255, green: 59/255, blue: 59/255, alpha: 1).cgColor]
        gradient.locations = [0.0, 0.3 ,0.7]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(gradient,at: 0)
        
    }
    
}


extension MainViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContetnForSearchText(searchController.searchBar.text!)
    }
}
