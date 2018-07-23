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
        cell.tweetLabel.text = tweet.text
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

