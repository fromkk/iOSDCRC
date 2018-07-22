//
//  TimesScrollView.swift
//  TimetableViewSampler
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

class TimesScrollView: UIScrollView {
    var startDate: Date?
    var endDate: Date?
    var heightOfHour: CGFloat
    init(startDate: Date?, endDate: Date?, heightOfHour: CGFloat) {
        self.startDate = startDate
        self.endDate = endDate
        self.heightOfHour = heightOfHour
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var setUp: () -> () = {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        showDates()
        
        return {}
    }()
    
    func update(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        
        labels.forEach { $0.removeFromSuperview() }
        showDates()
    }
    
    private func showDates() {
        guard let startDate = startDate, let endDate = endDate else { return }
        
        var currentDate: Date = startDate
        repeat {
            let diff = currentDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
            
            let y = height(for: diff)
            let label = makeLabel(with: currentDate.toString(with: "HH:mm"))
            label.frame = CGRect(x: 0, y: y, width: self.frame.size.width, height: 14)
            addSubview(label)
            labels.append(label)
            
            let next = nextHour(of: currentDate)
            currentDate = next
        } while currentDate < endDate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labels.forEach { label in
            var frame = label.frame
            frame.size.width = self.frame.size.width
            label.frame = frame
        }
        
        guard let startDate = startDate, let endDate = endDate else { return }
        
        self.contentSize = CGSize(width: self.frame.size.width, height: height(for: endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970))
    }
    
    private func nextHour(of date: Date) -> Date {
        let currentComponents = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        let nextComponents = DateComponents(calendar: .current, timeZone: .current, year: currentComponents.year!, month: currentComponents.month!, day: currentComponents.day!, hour: currentComponents.hour! + 1)
        return Calendar.current.date(from: nextComponents)!
    }
    
    private func height(for timeInterval: TimeInterval) -> CGFloat {
        let hour = timeInterval / 3600
        return heightOfHour * CGFloat(hour)
    }
    
    private var labels: [UILabel] = []
    
    private func makeLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        return label
    }
}
