//
//  SearchBar.swift
//  MyBrewery
//
//  Created by Finley on 2022/06/21.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class SearchBar : UIView{
    var beer = [Beer]()
    var filteringData = [String]()
    let disposbag = DisposeBag()
    
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationSearchBar(){
        searchBar
            .rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] newData in
                self.filteringData = self.beer?.filter{ $0.hasPrefix(newData) } as! [String]
                self.tableView.reloadData()
            })
            .disposed(by: disposbag)
    }
}
