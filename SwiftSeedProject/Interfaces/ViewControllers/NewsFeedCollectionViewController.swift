//
//  NewsFeedCollectionViewController.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/21/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Dip
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class NewsFeedCollectionViewController: UITableViewController {

    var viewModel: NewsFeedViewModel!
    private let disposeBag = DisposeBag()

    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ArticleViewModel>>(
        configureCell: { (_, tv, indexPath, viewModel) in
            let cell = tv.dequeueReusableCell(withIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
            cell.viewModel = viewModel
            cell.configureBindings()
            return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureBindings()
        viewModel.getArticles()
    }
    
    private func configureBindings() {
        viewModel.newsArticles
            .asObservable()
            .bind(to: tableView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        // This is necessary since the UITableViewController automatically set his tableview delegate and dataSource to self
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.tableFooterView = UIView() // Prevent empty rows
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
    }
}

extension NewsFeedCollectionViewController: StoryboardInstantiatable { }
