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

final class PostViewCell: UITableViewCell {
    
    static let identifier = "PostViewCell"
    static let Height = 80.0
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var viewModel: PostViewModel?

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
    }
}
