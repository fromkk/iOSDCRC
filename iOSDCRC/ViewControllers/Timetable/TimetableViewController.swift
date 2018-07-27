//
//  TimetableViewController.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit
import TimetableView

final class TimetableViewController: UIViewController, TimetableViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, TimetableViewpProtocol {
    
    let heightOfHour: CGFloat = 800
    
    let itemWidth: CGFloat = 240
    
    override func loadView() {
        super.loadView()
        
        title = "Timetable"
        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = .white
        view.addSubview(segmentedControl, constraints: [
            segmentedControlTopConstraint,
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 16),
            view.safeArea.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor, constant: 16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 24),
            ])
        
        view.addSubview(tracksScrollView, constraints: [
            tracksScrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tracksScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            tracksScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tracksScrollView.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        view.addSubview(timesScrollView, constraints: [
            timesScrollView.topAnchor.constraint(equalTo: tracksScrollView.bottomAnchor),
            timesScrollView.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor),
            timesScrollView.widthAnchor.constraint(equalToConstant: 60),
            timesScrollView.bottomAnchor.constraint(equalTo: view.safeArea.bottomAnchor)
            ])
        
        view.addSubview(timetableView, constraints: [
            timetableView.leadingAnchor.constraint(equalTo: timesScrollView.trailingAnchor),
            timetableView.topAnchor.constraint(equalTo: tracksScrollView.bottomAnchor),
            timetableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timetableView.bottomAnchor.constraint(equalTo: view.safeArea.bottomAnchor)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Elements
    
    lazy var presenter: TimetablePresenterProtocol = TimetablePresenter(dependencies: (
        view: self,
        interactor: TimetableInteractor()
    ))
    
    // MARK: - UI
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.tintColor = UIColor.rc.mainText
        segmentedControl.backgroundColor = .white
        segmentedControl.addTarget(self, action: #selector(onChange(segmentedControl:)), for: .valueChanged)
        return segmentedControl
    }()
    
    @objc private func onChange(segmentedControl: UISegmentedControl) {
        presenter.selectEvent(at: segmentedControl.selectedSegmentIndex)
    }
    
    lazy var segmentedControlTopConstraint: NSLayoutConstraint = {
        if #available(iOS 11.0, *) {
            return segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        } else {
            return segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        }
    }()
    
    private func makeTimetableConfiguration(with startDate: Date?, and endDate: Date?) -> TimetableViewConfiguration {
        return TimetableViewConfiguration(
            itemWidth: self.itemWidth,
            heightOfHour: self.heightOfHour,
            itemEdgeInsets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
            startDate: startDate,
            endDate: endDate,
            dataSource: self)
    }
    
    lazy var timetableView: TimetableView = {
        let timetableView = TimetableView(configuration: makeTimetableConfiguration(with: nil, and: nil))
        timetableView.backgroundColor = .white
        timetableView.register(TimetableCell.self, forCellWithReuseIdentifier: TimetableCell.reuseIdentifier)
        timetableView.delegate = self
        if #available(iOS 11.0, *) {
            timetableView.contentInsetAdjustmentBehavior = .never
        }
        return timetableView
    }()
    
    lazy var tracksScrollView: TracksScrollView = {
        let scrollView = TracksScrollView(trackNames: [], itemWidth: self.itemWidth)
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    lazy var timesScrollView: TimesScrollView = {
        let scrollView = TimesScrollView(startDate: nil, endDate: nil, heightOfHour: self.heightOfHour)
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    // MARK: - TimetableViewProtocol
    
    func showEvents() {
        segmentedControl.removeAllSegments()
        
        let width: CGFloat = segmentedControl.frame.size.width
        let itemWidth = width / CGFloat(presenter.numberOfEvents())
        (0..<presenter.numberOfEvents()).forEach { (index) in
            guard let event = presenter.event(at: index) else { return }
            segmentedControl.insertSegment(withTitle: event.startAt.toString(with: "yyyy/MM/dd"), at: index, animated: false)
            segmentedControl.setWidth(itemWidth, forSegmentAt: index)
            
            if presenter.currentEvent == event {
                segmentedControl.selectedSegmentIndex = index
            }
        }
    }
    
    func updateEvent() {
        guard let event = presenter.currentEvent else { return }
        
        timesScrollView.update(startDate: event.startAt, endDate: event.endAt)
        tracksScrollView.trackNames = event.tracks.map { $0.name }
        
        timetableView.configuration = makeTimetableConfiguration(with: event.startAt, and: event.endAt)
        timetableView.collectionViewLayout.invalidateLayout()
        timetableView.reloadData()
    }
    
    // MARK: - TimetableViewDataSource
    
    func numberOfSections(in timetableView: TimetableView) -> Int {
        guard let event = presenter.currentEvent else { return 0 }
        
        return event.tracks.count
    }
    
    func timetableView(_ timetableView: TimetableView, numberOfItemsIn section: Int) -> Int {
        guard let event = presenter.currentEvent else { return 0 }
        
        guard section < event.tracks.count else { return 0 }
        let track = event.tracks[section]
        return track.sessions.count
    }
    
    func timetableView(_ timetableView: TimetableView, itemAt indexPath: IndexPath) -> TimetableViewItem? {
        guard let event = presenter.currentEvent else { return nil }
        return event.tracks[indexPath.section].sessions[indexPath.item]
    }
    
    func timetableView(_ timetableView: TimetableView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TimetableCell.dequeue(for: timetableView, at: indexPath)
        
        if let event = presenter.currentEvent {
            cell.item = event.tracks[indexPath.section].sessions[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(timesScrollView) {
            var contentOffset = timetableView.contentOffset
            contentOffset.y = scrollView.contentOffset.y
            timetableView.contentOffset = contentOffset
        } else if scrollView.isEqual(tracksScrollView) {
            var contentOffset = timetableView.contentOffset
            contentOffset.x = scrollView.contentOffset.x
            timetableView.contentOffset = contentOffset
        } else if scrollView.isEqual(timetableView) {
            times: do {
                var contentOffset = timesScrollView.contentOffset
                contentOffset.y = scrollView.contentOffset.y
                timesScrollView.contentOffset = contentOffset
            }
            
            tracks: do {
                var contentOffset = tracksScrollView.contentOffset
                contentOffset.x = scrollView.contentOffset.x
                tracksScrollView.contentOffset = contentOffset
            }
        }
    }
    
}
