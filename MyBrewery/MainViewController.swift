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

class MainViewController: UIViewController {
    
    
    let beerList = BehaviorSubject<[Beer]>(value:[])
    let disposeBag = DisposeBag()
    var currentPage = 1
    
    let topLogo = UIImageView()
    let searchView = UISearchBar()
    let animationView = AnimationView(name: "yellowwave")
    let camera = UIButton()
    let album = UIButton()
    let beerListTableView = BeerListTableView()
    
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
        
        [animationView,camera,album,beerListTableView,topLogo].forEach{
            view.addSubview($0)
        }
        
        animationView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(-450)
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
        
        beerListTableView.snp.makeConstraints{
            $0.top.equalTo(topLogo.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        topLogo.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(50)
        }
    }
    
    private func configuration(){
        view.backgroundColor = .white
        
        topLogo.image = UIImage(named: "logo")
        
        animationView.loopMode = .loop
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi)
        
        camera.setImage(UIImage(systemName: "camera"), for: .normal)
        album.setImage(UIImage(systemName: "photo"), for: .normal)
        
        searchView.searchTextField.backgroundColor = UIColor.white
        
        beerListTableView.dataSource = self
        beerListTableView.delegate = self
        beerListTableView.layer.cornerRadius = 10
        beerListTableView.refreshControl = UIRefreshControl()
        
        let refreshControl = beerListTableView.refreshControl!
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "reload")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
        //검색결과
    }
    
    private func fetchBeer(of page: Int){
        Observable.from([page])
            .map { page -> URL in
                return URL(string: "https://api.punkapi.com/v2/beers?page=\(page)")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
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
                return objects.compactMap{ dic -> Beer? in
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let tagline = dic["tagline"] as? String,
                          let description = dic["description"] as? String,
                          let brewersTips = dic["brewersTips"] as? String,
                          let imageURL = dic["imageURL"] as? String,
                          let foodParing = dic["foodParing"] as? [String] else { return nil }
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
        do{
            return try beerList.value().count
        } catch{
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
}
