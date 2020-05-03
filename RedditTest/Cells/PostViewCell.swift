//
//  NewsCollectionViewCell.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 4/18/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class PostViewCell: UITableViewCell {
    
    static let identifier = "PostViewCell"
    static let Height = 80.0

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var vwNotRead: UIView!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var notReadViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var authorLabelLeadingConstraint: NSLayoutConstraint!

    var viewModel: PostViewModel? {
        didSet {
            self.disposeBag = DisposeBag()
            configureBindings()
        }
    }
    var disposeBag = DisposeBag()
    
    let vwNotReadWidth: CGFloat = 10
    let authorLabelLeading: CGFloat = 5
    
    public func setupUI() {
        self.vwNotRead.layer.cornerRadius = self.vwNotRead.bounds.size.height / 2
    }

    public func configureBindings() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.title
            .asObservable()
            .bind(to: lblTitle.rx.text)
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
        
        viewModel.numComments
            .asObservable()
            .map { "\($0) comments" }
            .bind(to: lblComments.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.wasViewed
            .asObservable()
            .bind { [weak self] wasViewed in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.vwNotRead.isHidden = wasViewed
                weakSelf.notReadViewWidthConstraint.constant = wasViewed ? 0 : weakSelf.vwNotReadWidth
                weakSelf.authorLabelLeadingConstraint.constant = wasViewed ? 0 : weakSelf.authorLabelLeading
            }
            .disposed(by: disposeBag)
    }
}
