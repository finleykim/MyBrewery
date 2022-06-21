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
import RxSwift
import RxCocoa
import SwiftUI

class MainViewController: UIViewController {
    
    
    let beerList = BehaviorSubject<[Beer]>(value:[])
    var filterBeerList = BehaviorSubject<[Beer]>(value:[])
    let disposeBag = DisposeBag()
    var currentPage = 1
    
    let topLogo = UIImageView()
    let searchBar = UISearchBar()
    let animationView = AnimationView(name: "yellowwave")
    let cameraButton = UIButton()
    let beerListTableView = BeerListTableView()
//    let searchTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewSetup()
        configuration()
        fetchBeer(of: self.currentPage)
    }
    
    private func addViewSetup(){
        
        [topLogo,searchBar,beerListTableView,cameraButton].forEach{
            view.addSubview($0)
        }
        
        topLogo.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.snp.makeConstraints{
            $0.top.equalTo(topLogo.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        beerListTableView.snp.makeConstraints{
            $0.top.equalTo(topLogo.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        
//        searchTableView.snp.makeConstraints{
//            $0.edges.equalToSuperview()
//        }
    }
    
    private func configuration(){
        view.backgroundColor = .black
        
        topLogo.image = UIImage(named: "logo")
        
        searchBar.searchTextField.backgroundColor = UIColor.white
        
        beerListTableView.dataSource = self
        beerListTableView.delegate = self
        beerListTableView.backgroundColor = .white
        beerListTableView.refreshControl = UIRefreshControl()
        
        cameraButton.backgroundColor = .black
        cameraButton.tintColor = .white
        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
        cameraButton.layer.cornerRadius = 40
        
        let refreshControl = beerListTableView.refreshControl!
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "reload")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
//        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerListTableViewCell")
//        searchTableView.delegate = self
//        searchTableView.dataSource = self
//        searchTableView.isHidden = true
    }
    
    @objc func refresh(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.fetchBeer(of: self.currentPage)
        }
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
        Observable.from([searchText])
            .map { page -> URL in
                return URL(string: "https://api.punkapi.com/v2/beers?page=\(searchText)")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap{ request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .filter{ responds, _ in
                return 200..<300 ~= responds.statusCode
            }
            .map { _, data -> [[String : Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String : Any]] else {
                    return []
                }
                
                return result
            }
            .filter { result in
                
                return result.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> Beer? in
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let tagline = dic["tagline"] as? String,
                          let description = dic["description"] as? String,
                          let brewersTips = dic["brewers_tips"] as? String,
                          let imageURL = dic["image_url"] as? String,
                          let foodParing = dic["food_pairing"] as? [String] else {
                        return nil
                    }
                    return Beer(id: id, name: name, tagline: tagline, description: description, brewersTips: brewersTips, imageURL: imageURL, foodParing: foodParing)
                }
            }
            .subscribe(onNext:{ [weak self] searchBeer in
                self?.beerList.onNext(searchBeer)
                DispatchQueue.main.async{
                    self?.beerListTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchBeer(of page: Int){
        Observable.from([page])
            .map { page -> URL in
                return URL(string: "https://api.punkapi.com/v2/beers?page=\(page)")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap{ request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .filter{ responds, _ in
                return 200..<300 ~= responds.statusCode
            }
            .map { _, data -> [[String : Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String : Any]] else {
                    return []
                }
                
                return result
            }
            .filter { result in
                
                return result.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> Beer? in
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let tagline = dic["tagline"] as? String,
                          let description = dic["description"] as? String,
                          let brewersTips = dic["brewers_tips"] as? String,
                          let imageURL = dic["image_url"] as? String,
                          let foodParing = dic["food_pairing"] as? [String] else {
                        return nil
                    }
                    return Beer(id: id, name: name, tagline: tagline, description: description, brewersTips: brewersTips, imageURL: imageURL, foodParing: foodParing)
                }
            }
            .subscribe(onNext:{ [weak self] newBeer in
                self?.beerList.onNext(newBeer)
                self?.currentPage += 1
                DispatchQueue.main.async{
                    self?.beerListTableView.reloadData()
                    self?.beerListTableView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }

}




extension MainViewController: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return }
        indexPaths.forEach({
            if ($0.row + 1)/25 + 1 == currentPage{
                self.fetchBeer(of: currentPage)
            }
        })
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try beerList.value().count
        } catch {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListTableViewCell") as? BeerListTableViewCell else { return UITableViewCell() }
        var currentRepo: Beer?{
            do{
                return try beerList.value()[indexPath.row]
            } catch{
                return nil
            }
        }
        cell.beer = currentRepo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        do{
            let selectedBeer = try beerList.value()[indexPath.row]
            let detailViewController = DetailViewController()
            detailViewController.beer = selectedBeer
            self.show(detailViewController, sender: nil)
        } catch{
            print("알 수 없는 오류")
        }
    }
    
}

extension MainViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContetnForSearchText(searchController.searchBar.text!)
    }
}
