//
//  SourceListViewController.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 3/17/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Dip
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class PostListViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!

    var viewModel: PostListViewModel!
    private let cellIdentifier = "PostViewCell"
    private let disposeBag = DisposeBag()

    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, PostViewModel>>(
        configureCell: { (_, tv, indexPath, viewModel) in
            let cell = tv.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
            cell.viewModel = viewModel
            cell.configureBindings()
            return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top in CryptoCurrencies Subreddit"
        viewModel.navigationDelegate = self
        setupTableView()
        configureBindings()
        viewModel.getTopPosts()
    }
    
    private func configureBindings() {
        viewModel.posts
            .asObservable()
            .bind(to: postsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        // This is necessary since the UITableViewController automatically set his tableview delegate and dataSource to self
        postsTableView.tableFooterView = UIView() // Prevent empty rows
        postsTableView.rowHeight = UITableViewAutomaticDimension
        postsTableView.estimatedRowHeight = 400
    }
}

extension PostListViewController: StoryboardInstantiatable { }
