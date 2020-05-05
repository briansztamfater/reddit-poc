//
//  SourceListViewController.swift
//  RedditTest
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
    @IBOutlet weak var btnDismissAll: UIButton!
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let refreshControl = UIRefreshControl()

    var viewModel: PostListViewModel!
    var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, PostViewModel>>? = nil

    private let cellIdentifier = "PostViewCell"
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top in r/CryptoCurrencies"
        viewModel.navigationDelegate = self
        setupUI()
        setupTableView()
        configureBindings()
        viewModel.getTopPosts()
    }
    
    private func setupUI() {
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.postsTableView.addSubview(refreshControl)
        
        dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, PostViewModel>>(
            configureCell: { (_, tv, indexPath, viewModel) in
                let cell = tv.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
                cell.viewModel = viewModel
                cell.setupUI()
                cell.btnDismiss.rx
                    .tap
                    .asDriver()
                    .drive(onNext: { [weak self] in
                        guard let weakSelf = self else {
                            return
                        }
                        weakSelf.viewModel.deletePost(from: viewModel)
                    })
                    .disposed(by: cell.disposeBag)
                return cell
        })
        dataSource!.canEditRowAtIndexPath = { dataSource, indexPath  in
          return true
        }
    }
    
    private func configureBindings() {
        viewModel.posts
            .asObservable()
            .distinctUntilChanged()
            .bind(to: postsTableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                guard let weakSelf = self else {
                    return
                }
                if isLoading {
                    DispatchQueue.main.async {
                        weakSelf.activityIndicator.startAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        weakSelf.activityIndicator.stopAnimating()
                        weakSelf.refreshControl.endRefreshing()
                    }
                }
            })
            .disposed(by: disposeBag)

        postsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.postsTableView?.deselectRow(at: indexPath, animated: true)
                weakSelf.viewModel.selectPost(at: indexPath.row)
                weakSelf.postsTableView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        postsTableView.rx
            .itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.viewModel.deletePost(at: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        postsTableView.rx.didEndDragging
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else {
                    return
                }
                let currentOffset = weakSelf.postsTableView.contentOffset.y
                let maximumOffset = weakSelf.postsTableView.contentSize.height - weakSelf.postsTableView.frame.size.height
                if maximumOffset - currentOffset <= 10.0 {
                    weakSelf.viewModel.getTopPosts(forceLoad: true)
                }

            })
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.viewModel.refreshAll()
            })
            .disposed(by: disposeBag)

        btnDismissAll.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.viewModel.deleteAll()
            })
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
