//
//  TimelineViewController.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol TimelineViewProtocol: class {
    func showTimeline()
    func showAlertTokenGetFailed()
    func showAlertTimelineGetFailed()
}

class TimelineViewController: UITableViewController, TimelineViewProtocol {

    override func loadView() {
        super.loadView()
        
        title = "Timeline"
        
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadTimeline()
    }
    
    // MARK: - Elements
    
    lazy var presenter: TimelinePresenterProtocol = TimelinePresenter(dependencies: (
        view: self,
        interactor: TimelineInteractor()
    ))

    // MARK: - TimelineViewProtocol
    
    func showTimeline() {
        tableView.reloadData()
    }
    
    func showAlertTokenGetFailed() {
        debugPrint(#function)
    }
    
    func showAlertTimelineGetFailed() {
        debugPrint(#function)
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
            .foregroundColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ])
        
        name.append(NSAttributedString(string: String(format: " @%@", tweet.user.screenName), attributes: [
            .foregroundColor: #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),
            .font: UIFont.systemFont(ofSize: 14, weight: .light)
            ]))
        
        cell.nameLabel.attributedText = name
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4.0
        cell.tweetLabel.attributedText = NSAttributedString(string: tweet.text, attributes: [
            .paragraphStyle: style,
            .font: UIFont.systemFont(ofSize: 14, weight: .light),
            .foregroundColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
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
}

