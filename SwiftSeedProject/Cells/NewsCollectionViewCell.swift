//
//  NewsCollectionViewCell.swift
//  SwiftSeedProject
//
//  Created by Brian Sztamfater on 4/18/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class NewsCollectionViewCell: UITableViewCell {
    
    static let identifier = "NewsCollectionViewCell"
    static let Height = 80.0
    
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    
    var viewModel: ArticleViewModel?

    var disposeBag = DisposeBag()

    override public func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

    public func configureBindings() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.title
            .asObservable()
            .bind(to: lblTitle.rx.text)
            .disposed(by: disposeBag)

        viewModel.description
            .asObservable()
            .bind(to: lblDescription.rx.text)
            .disposed(by: disposeBag)

        viewModel.author
            .asObservable()
            .bind(to: lblAuthor.rx.text)
            .disposed(by: disposeBag)

        viewModel.date
            .asObservable()
            .map { "\($0)" }
            .bind(to: lblDate.rx.text)
            .disposed(by: disposeBag)

        viewModel.imageUrl
            .asObservable()
            .bind { [weak self] imageUrl in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.imgDetail.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage())
            }
            .disposed(by: disposeBag)
    }
}
