//
//  PostDetailsViewController.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import UIKit
import Combine

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwHeader: UIView!

    @Inject private var viewModel: PostDetailsViewModel

    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.navigationDelegate = self
        configureBindings()
    }

    private func configureBindings() {
        viewModel.$title
            .assign(to: \.text, on: lblTitle)
            .store(in: &cancellables)

        viewModel.$title
            .sink { [weak self] title in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.title = title
                // Hide UI elements if no post is provided
                weakSelf.lblTitle.isHidden = title!.count == 0
                weakSelf.vwHeader.isHidden = title!.count == 0
                weakSelf.imgThumbnail.isHidden = title!.count == 0
            }
            .store(in: &cancellables)

        viewModel.$author
            .assign(to: \.text, on: lblAuthor)
            .store(in: &cancellables)

        viewModel.$publishedAt
            .map { "(\($0.localTime().timeAgo()))" }
            .assign(to: \.text, on: lblDate)
            .store(in: &cancellables)
        
        viewModel.$title
            .sink { [weak self] title in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.title = title
                // Hide UI elements if no post is provided
                weakSelf.lblTitle.isHidden = title!.count == 0
                weakSelf.vwHeader.isHidden = title!.count == 0
                weakSelf.imgThumbnail.isHidden = title!.count == 0
            }
            .store(in: &cancellables)
        
        viewModel.$thumbnail
            .sink { [weak self] imageUrl in
                guard let weakSelf = self else {
                   return
                }
                weakSelf.imgThumbnail.loadImage(withUrl: imageUrl)
            }
            .store(in: &cancellables)
    }
}
