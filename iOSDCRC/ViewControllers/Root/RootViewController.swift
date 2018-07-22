//
//  RootViewController.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol RootViewProtocol: class {
    func showMenu()
}

final class RootViewController: UITableViewController, RootViewProtocol {
    
    private let reuseIdentifier: String = "Cell"
    
    override func loadView() {
        super.loadView()
        
        title = "iOSDCRC 2018"
        tableView.tableHeaderView = logoView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfMenus()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = presenter.menu(at: indexPath.row)?.toString()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.select(at: indexPath.row)
    }
    
    // MARK: - Elements
    
    lazy var presenter: RootPresenterProtocol = RootPresenter(dependencies: (
        view: self,
        interactor: RootInteractor(),
        router: RootWireframe(viewController: self)
    ))
    
    // MARK: - UI
    
    lazy var logoView: RootLogoView = RootLogoView(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 200)))
    
    // MARK: - RootViewProtocol
    
    func showMenu() {
        tableView.reloadData()
    }
}
