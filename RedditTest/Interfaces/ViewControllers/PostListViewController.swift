//
//  SourceListViewController.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 3/17/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import UIKit
import Combine
import Foundation

class PostListViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var btnDismissAll: UIButton!
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let refreshControl = UIRefreshControl()

    @Inject private var viewModel: PostListViewModel

    private let cellIdentifier = "PostViewCell"
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top in r/CryptoCurrencies"
        viewModel.navigationDelegate = self
        setupUI()
        setupTableView()
        configureBindings()
    }
    
    private func setupUI() {
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:  #selector(refreshAll), for: .valueChanged)
        self.postsTableView.addSubview(refreshControl)
    }
    
    private func configureBindings() {
        viewModel.$isLoading
            .sink { [weak self] isLoading in
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
                DispatchQueue.main.async {
                    weakSelf.postsTableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        // This is necessary since the UITableViewController automatically set his tableview delegate and dataSource to self
        postsTableView.tableFooterView = UIView() // Prevent empty rows
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 400
    }
    
    @objc private func refreshAll() {
        viewModel.refreshAll()
    }
    
    @IBAction func dismissAll() {
        viewModel.deleteAll()
        let count = postsTableView.numberOfRows(inSection: 0);
        let indexPaths = (0..<count).map { IndexPath(row: $0, section: 0) }
        postsTableView.deleteRows(at: indexPaths, with: .fade)
    }
}

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectPost(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deletePost(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = postsTableView.contentOffset.y
        let maximumOffset = postsTableView.contentSize.height - postsTableView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 {
            viewModel.getTopPosts(forceLoad: true)
        }
    }
}

extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postViewModel = viewModel.posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
        cell.viewModel = postViewModel
        cell.setupUI()
        cell.dismissButtonBlock = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.viewModel.deletePost(from: postViewModel)
            weakSelf.postsTableView.deleteRows(at: [weakSelf.postsTableView.indexPath(for: cell)!], with: UITableView.RowAnimation.automatic)
        }
        return cell
    }
}
