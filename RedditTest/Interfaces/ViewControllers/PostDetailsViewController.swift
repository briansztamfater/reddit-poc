//
//  PostDetailsViewController.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 02/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwHeader: UIView!

    @Inject private var viewModel: PostDetailsViewModel
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.navigationDelegate = self
        configureBindings()
    }

    private func configureBindings() {
        viewModel.title
           .asObservable()
           .bind(to: lblTitle.rx.text)
           .disposed(by: disposeBag)

        viewModel.title
            .asObservable()
            .bind { [weak self] title in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.title = title
                // Hide UI elements if no post is provided
                weakSelf.lblTitle.isHidden = title.count == 0
                weakSelf.vwHeader.isHidden = title.count == 0
                weakSelf.imgThumbnail.isHidden = title.count == 0
            }
            .disposed(by: disposeBag)

       viewModel.author
           .asObservable()
           .bind(to: lblAuthor.rx.text)
           .disposed(by: disposeBag)

       viewModel.publishedAt
           .asObservable()
           .map { "(\($0.localTime().timeAgo()))" }
           .bind(to: lblDate.rx.text)
           .disposed(by: disposeBag)

       viewModel.thumbnailUrl
           .asObservable()
           .bind { [weak self] imageUrl in
               guard let weakSelf = self else {
                   return
               }
               weakSelf.imgThumbnail.sd_setImage(with: imageUrl, placeholderImage: UIImage())
           }
           .disposed(by: disposeBag)
    }
}
