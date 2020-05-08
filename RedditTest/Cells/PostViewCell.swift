//
//  NewsCollectionViewCell.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 4/18/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import UIKit
import Combine

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
    var dismissButtonBlock : (() -> ())?

    var viewModel: PostViewModel? {
        didSet {
            self.cancellables.forEach{ $0.cancel() }
            self.cancellables = []
            configureBindings()
        }
    }
    private var cancellables: Set<AnyCancellable> = []

    let vwNotReadWidth: CGFloat = 10
    let authorLabelLeading: CGFloat = 5
    
    override func prepareForReuse() {
        imgThumbnail.image = nil
    }

    public func setupUI() {
        self.vwNotRead.layer.cornerRadius = self.vwNotRead.bounds.size.height / 2
    }
    
    public func configureBindings() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.$title
            .map { "\($0)" }
            .assign(to: \.text, on: lblTitle)
            .store(in: &cancellables)

        viewModel.$author
            .map { "\($0)" }
            .assign(to: \.text, on: lblAuthor)
            .store(in: &cancellables)

        viewModel.$publishedAt
            .map { "(\($0.localTime().timeAgo()))" }
            .assign(to: \.text, on: lblDate)
            .store(in: &cancellables)

        viewModel.$thumbnailUrl
            .sink { [weak self] imageUrl in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.imgThumbnail.loadImage(withUrl: imageUrl)
            }
            .store(in: &cancellables)

        viewModel.$numComments
            .map { "\($0) comments" }
            .assign(to: \.text, on: lblComments)
            .store(in: &cancellables)

        viewModel.$wasViewed
            .sink { [weak self] wasViewed in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.vwNotRead.isHidden = wasViewed
                weakSelf.notReadViewWidthConstraint.constant = wasViewed ? 0 : weakSelf.vwNotReadWidth
                weakSelf.authorLabelLeadingConstraint.constant = wasViewed ? 0 : weakSelf.authorLabelLeading
            }
            .store(in: &cancellables)
    }
    
    @IBAction func dismissPost(){
      dismissButtonBlock?()
    }
}
