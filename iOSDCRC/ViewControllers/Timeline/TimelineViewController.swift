//
//  TimelineViewController.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

/// Twitterのタイムラインを表示
class TimelineViewController: UITableViewController, TimelineViewProtocol, Injectable {
    
    // MARK: - Dependency
    
    typealias Dependency = TimelinePresenterProtocol
    private var presenter: TimelinePresenterProtocol!
    func inject(dependency: TimelinePresenterProtocol) {
        presenter = dependency
    }
    
    // MARK: - lifecycle
    
    override func loadView() {
        super.loadView()
        
        title = "Timeline"
        
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.reuseIdentifier)
        
        view.addSubview(loadingView, constraints: [
            loadingView.widthAnchor.constraint(equalTo: view.widthAnchor),
            loadingView.heightAnchor.constraint(equalTo: view.heightAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadTimeline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillShow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillHide()
    }
    
    // MARK: - UI
    
    lazy var loadingView = LoadingView()
    
    lazy var footerLoadingView: LoadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.size.width, height: 44)))

    // MARK: - TimelineViewProtocol
    
    func showLoading() {
        loadingView.startAnimating()
    }
    
    func hideLoading() {
        loadingView.stopAnimating()
    }
    
    func showLoadingBottom() {
        tableView.tableFooterView = footerLoadingView
        footerLoadingView.startAnimating()
    }
    
    func hideLoadingBottom() {
        footerLoadingView.stopAnimating()
        tableView.tableFooterView = nil
    }
    
    func showTimeline() {
        tableView.reloadData()
    }
    
    func addTimeline(at indexes: [Int]) {
        let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
        if indexes.contains(0) {
            tableView.insertRows(at: indexPathes, with: .automatic)
        } else {
            tableView.insertRows(at: indexPathes, with: .bottom)
        }
    }
    
    func updateDate() {
        (0..<presenter.numberOfTweets()).forEach { index in
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? TimelineCell, let tweet = presenter.tweet(at: index) else { return }
            cell.dateLabel.text = TweetDateConverter.convert(tweet.createdAt)
        }
    }
    
    func showAlertTokenGetFailed() {
        let alertController = UIAlertController(title: Localizations.Timeline.Alert.AccessTokenGetFailed.title.localize(), message: Localizations.Timeline.Alert.AccessTokenGetFailed.message.localize(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Localizations.General.ok.localize(), style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showAlertTimelineGetFailed() {
        let alertController = UIAlertController(title: Localizations.Timeline.Alert.TweetGetFailed.title.localize(), message: Localizations.Timeline.Alert.TweetGetFailed.message.localize(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Localizations.General.ok.localize(), style: .default, handler: nil))
        present(alertController, animated: true)
    }

    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfTweets()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TimelineCell.dequeue(for: tableView, at: indexPath)
        if let tweet = presenter.tweet(at: indexPath.row) {
            configure(cell, and: tweet)
        }
        return cell
    }
    
    private func configure(_ cell: TimelineCell, and tweet: Twitter.Response.Status) {
        let name: NSMutableAttributedString = NSMutableAttributedString(string: tweet.user.name, attributes: [
            .foregroundColor: UIColor.rc.mainText,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ])
        
        name.append(NSAttributedString(string: String(format: " @%@", tweet.user.screenName), attributes: [
            .foregroundColor: UIColor.rc.subText,
            .font: UIFont.systemFont(ofSize: 14, weight: .light)
            ]))
        
        cell.nameLabel.attributedText = name
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4.0
        cell.tweetLabel.attributedText = NSAttributedString(string: tweet.text, attributes: [
            .paragraphStyle: style,
            .font: UIFont.systemFont(ofSize: 14, weight: .light),
            .foregroundColor: UIColor.rc.mainText
            ])
        cell.dateLabel.text = TweetDateConverter.convert(tweet.createdAt)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TimelineCell, let tweet = presenter.tweet(at: indexPath.row) else { return }
        
        cell.iconImageView.image = nil
        cell.task = ImageLoader.load(with: tweet.user.profileImageUrlHttps, completion: { (image, error) in
            guard let image = image, cell.task?.url == tweet.user.profileImageUrlHttps else { return }
            cell.iconImageView.image = image
        })
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TimelineCell else { return }
        cell.task?.cancel()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height) < 200.0 else { return }
        presenter.findOldTweets()
    }
}

