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

class SourceListViewController: UIViewController {

    @IBOutlet weak var sourcesTableView: UITableView!

    var viewModel: SourceListViewModel!
    private let cellIdentifier = "SourceCell"
    private let disposeBag = DisposeBag()

    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SourceViewModel>>(
        configureCell: { (_, tv, indexPath, viewModel) in
            let cell = tv.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath)
            viewModel.name
                .asObservable()
                .bind(to: cell.textLabel!.rx.text)
                .disposed(by: DisposeBag())
            return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sources"
        viewModel.navigationDelegate = self
        setupTableView()
        configureBindings()
        viewModel.getSources()
    }
    
    private func configureBindings() {
        viewModel.sources
            .asObservable()
            .bind(to: sourcesTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        sourcesTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let weakSelf = self else {
                    return
                }
                let source = weakSelf.viewModel.sources.value.first!.items[indexPath.row]
                weakSelf.viewModel.selectSource(source)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        sourcesTableView.tableFooterView = UIView() // Prevent empty rows
    }
}

extension SourceListViewController: StoryboardInstantiatable { }
