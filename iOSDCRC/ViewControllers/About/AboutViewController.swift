//
//  AboutViewController.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/26.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

final class AboutViewController: UITableViewController, AboutViewProtocol, Injectable {
    
    // MARK: - Dependency
    
    typealias Dependency = AboutPresenterProtocol
    var presenter: AboutPresenterProtocol!
    func inject(dependency: AboutPresenterProtocol) {
        self.presenter = dependency
    }
    
    override func loadView() {
        super.loadView()
        
        title = "About"
        
        tableView.register(AboutSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: AboutSectionHeaderView.reuseIdentifier)
        tableView.register(AboutCell.self, forCellReuseIdentifier: AboutCell.reuseIdentifier)
        
        presenter.loadAbout()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = AboutSectionHeaderView.dequeue(for: tableView)
        headerView.titleLabel.text = presenter.section(at: section)?.description
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = presenter.section(at: indexPath.section) else {
            fatalError("section get failed")
        }
        
        let cell = AboutCell.dequeue(for: tableView, at: indexPath)
        
        switch section {
        case .dates:
            configure(cell: cell, at: indexPath.row, with: presenter.date(at: indexPath.row))
        case .locations:
            configure(cell: cell, at: indexPath.row, with: presenter.location(at: indexPath.row))
        case .sponsors:
            configure(cell: cell, at: indexPath.row, with: presenter.sponsor(at: indexPath.row))
        case .speakers:
            configure(cell: cell, at: indexPath.row, with: presenter.speaker(at: indexPath.row))
        case .staffs:
            configure(cell: cell, at: indexPath.row, with: presenter.staff(at: indexPath.row))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    private func configure(cell: AboutCell, at index: Int, with dateRange: AboutEntity.DateRange?) {
        guard let dateRange = dateRange else {
            cell.descriptionLabel.text = nil
            cell.descriptionLabel.attributedText = nil
            return
        }
        
        cell.descriptionLabel.attributedText = nil
        cell.descriptionLabel.text = String(format: "%@ - %@", dateRange.from.toString(with: "yyyy/MM/dd HH:mm"), dateRange.to.toString(with: "yyyy/MM/dd HH:mm"))
    }
    
    private func configure(cell: AboutCell, at index: Int, with location: AboutEntity.Location?) {
        guard let location = location else {
            cell.descriptionLabel.text = nil
            cell.descriptionLabel.attributedText = nil
            return
        }
        
        cell.descriptionLabel.text = String(format: "%@\n〒%@\n%@", location.name, location.postalCode, location.address)
    }
    
    private func configure(cell: AboutCell, at index: Int, with twitterAccount: AboutEntity.TwitterAccount?) {
        guard let twitterAccount = twitterAccount else {
            cell.descriptionLabel.text = nil
            cell.descriptionLabel.attributedText = nil
            return
        }
        
        let attributedText = NSMutableAttributedString(string: twitterAccount.name, attributes: [
            .foregroundColor: UIColor.rc.mainText,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ])
        
        attributedText.append(NSAttributedString(string: String(format: " %@", twitterAccount.account), attributes: [
            .foregroundColor: UIColor.rc.subText,
            .font: UIFont.systemFont(ofSize: 14, weight: .light)
            ]))
        
        cell.descriptionLabel.text = nil
        cell.descriptionLabel.attributedText = attributedText
    }
    
    private func configure(cell: AboutCell, at index: Int, with sponsor: AboutEntity.Sponsor?) {
        guard let sponsor = sponsor else {
            cell.descriptionLabel.text = nil
            return
        }
        
        cell.descriptionLabel.text = String(format: "%@(%@)", sponsor.name, sponsor.description)
    }
    
    // MARK: - AboutViewProtocol
    
    func showAbout() {
        tableView.reloadData()
    }
    
}
